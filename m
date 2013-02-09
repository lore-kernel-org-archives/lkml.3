Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446Ab3BIRGG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 12:06:06 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:58208 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760759Ab3BIRGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 12:06:04 -0500
Message-ID: <511681F6.4010102@gmail.com>
Date: Sat, 09 Feb 2013 18:05:58 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Benoit Thebaudeau <benoit.thebaudeau@advansee.com>,
        David Hardeman <david@hardeman.nu>, Trilok Soni <tsoni@codeaurora.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Matus Ujhelyi <ujhelyi.m@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2] media: rc: gpio-ir-recv: add support for device tree
 parsing
References: <1360137832-13086-1-git-send-email-sebastian.hesselbarth@gmail.com> <1360355887-19973-1-git-send-email-sebastian.hesselbarth@gmail.com> <20130208220357.198c313c@redhat.com> <51159C36.1060602@gmail.com>
In-Reply-To: <51159C36.1060602@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2013 01:45 AM, Sebastian Hesselbarth wrote:
>>> new file mode 100644
>>> index 0000000..8589f30
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/media/gpio-ir-receiver.txt
>>> @@ -0,0 +1,16 @@
>>> +Device-Tree bindings for GPIO IR receiver
>>> +
>>> +Required properties:
>>> + - compatible = "gpio-ir-receiver";
>>> + - gpios: OF device-tree gpio specification.
>>> +
>>> +Optional properties:
>>> + - linux,rc-map-name: Linux specific remote control map name.
>>> +
>>> +Example node:
>>> +
>>> + ir: ir-receiver {
>>> + compatible = "gpio-ir-receiver";
>>> + gpios =<&gpio0 19 1>;
>>> + linux,rc-map-name = "rc-rc6-mce";
>>
>> Please change this to:
>> linux,rc-map-name = RC_MAP_RC6_MCE;
>>
>> (as defined at include/media/rc-map.h).
>
> Mauro,
>
> this is not possible in device tree bindings. Device tree properties
> can only carry numeric or string types (and some other stuff) but no
> OS specific enumerations. So using strings is the only option here.
>
>> The idea of having those strings defined at the same header file is to:
>
> Unfortunately, device tree blobs don't know about linux header files.

I suppose this will change when it will be possible to run C pre-processor
on *.dts files. This is still under discussion though [1] and for the
device tree there will likely be separate copies of the header files
needed. Thus I guess explicit string names for now need to be used.

[1] http://www.spinics.net/lists/kernel/msg1458360.html

