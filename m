Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760276Ab3BHTEB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 14:04:01 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:9482 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760225Ab3BHTD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 14:03:59 -0500
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f6d6d000001620-6b-51154c1dcd43
Message-id: <51154C1B.1030604@samsung.com>
Date: Fri, 08 Feb 2013 20:03:55 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Benoit Thebaudeau <benoit.thebaudeau@advansee.com>,
        David Hardeman <david@hardeman.nu>, Trilok Soni <tsoni@codeaurora.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH RESEND] media: rc: gpio-ir-recv: add support for device
 tree parsing
References: <1359400023-25804-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1360137832-13086-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <51125F44.3050603@samsung.com> <5112905E.3020400@gmail.com>
In-reply-to: <5112905E.3020400@gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCLMWRmVeSWpSXmKPExsVy+t/xK7qyPqKBBscuCVosbFvCYnF51xw2
	i54NW1kdmD0+b5ILYIzisklJzcksSy3St0vgytj+fy9jwXThij/rJrA1MG7m72Lk5JAQMJE4
	/eQkE4QtJnHh3nq2LkYuDiGBpYwS81dcBUvwCghK/Jh8j6WLkYODWUBe4silbJAws4C6xKR5
	i5gh6j8xSvxY/J4Zol5L4vj9+ewg9SwCqhJTt/mDhNkEDCV6j/YxgtiiAgESi5ecAysREbCW
	eNFSAjKGWWAhs8SUr23sIDXCAlESU3/sYYKYf5lRYv3ec6wgCU4BTYl3t68yT2AUmIXkvFkI
	581Cct4CRuZVjKKppckFxUnpuYZ6xYm5xaV56XrJ+bmbGCEh+WUH4+JjVocYBTgYlXh4V8iJ
	BgqxJpYVV+YeYpTgYFYS4d1mCxTiTUmsrEotyo8vKs1JLT7EyMTBKdXAmHXK0Dv00t89Gi+m
	CiX/Kt2kxLFHznTBk/Wyvyr6vHYe5BU+8rxIyThQ8MOuN0biR+4kSrTJ5Rav55PlOXdR4NGk
	eaei7jbyX32UeXGxfNz012l80nor84vPbC16Llc2w2bZF4/Kl1+YfqqXTlc7JJa9vWir3eEm
	yY0LlNTtywJiLDvq+VbuV2Ipzkg01GIuKk4EAMY5e0cnAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2013 06:18 PM, Sebastian Hesselbarth wrote:
>>> +Optional properties:
>>> +    - linux,allowed-rc-protocols: Linux specific u64 bitmask of allowed
>>> +        rc protocols.
>>
>> You likely need to specify in these bindings documentation which bit
>> corresponds to which RC protocol.
>>
>> I'm not very familiar with the RC internals, but why it has to be
>> specified statically in the device tree, when decoding seems to be
>> mostly software defined ? I might be missing something though..
> 
> Sylwester,
> 
> I am not familiar with RC internals either. Maybe somebody with more
> insight in media/rc can clarify the specific needs for the rc subsystem.
> I was just transferring the DT support approach taken by gpio_keys to
> gpio_ir_recv as I will be using it on mach-dove/cubox soon.
> 
>> Couldn't this be configured at run time, with all protocols allowed
>> as the default ?
> 
> Actually, this is how the internal rc code works. If there is nothing
> defined for allowed_protocols it assumes that all protocols are supported.
> That is why above node properties are optional.
> 
> About the binding documentation of allowed_protocols, rc_map, or the
> default behavior of current linux code, I don't think they will stay
> in-sync for long. I'd rather completely remove those os-specific properties
> from DT, but that hits the above statement about the needs of media/rc
> subsystem.

I think the bindings could define the bitmask, independently of the
RC code. I suppose it is correct to have a list of protocols defined
this way. Since, as Mauro pointed out, it is needed for some hardware
devices that support only selected protocols.
Then you could probably drop the 'linux,' prefix, but I'm not 100% sure
about it.

> Actually, I am not assigning the parsed gpio_ir_recv_platform_data to
> pdev->dev.platform_data but pdata ptr instead. Either I don't see the
> difference in pointer assignments between your code and mine or you
> were mislead from struct gpio_ir_recv_platform_data above.

Sorry, you're right. I think I was just trying to be to quick with this
review.. Your code is correct, however I would probably avoid the ERR_PTR()
pattern as much as possible.

> Anyway, I agree to test for pdev->dev.of_node and call gpio_ir_recv_parse_dt
> if set.

--
Regards,
Sylwester




-- 
Sylwester Nawrocki
실베스터 나브로츠키
Samsung Poland R&D Center
