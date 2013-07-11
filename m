Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab3GKWEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 18:04:50 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:44410 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782Ab3GKWEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 18:04:46 -0400
Message-ID: <51DF2BF6.30509@gmail.com>
Date: Fri, 12 Jul 2013 00:04:38 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 2/2] media: i2c: tvp7002: add OF support
References: <1371923055-29623-1-git-send-email-prabhakar.csengg@gmail.com> <1371923055-29623-3-git-send-email-prabhakar.csengg@gmail.com> <51D05568.3090009@gmail.com> <CA+V-a8sW+D8trces5AXu__Lw9F7TO6fCcQW+LGZKRhA41uOEfw@mail.gmail.com>
In-Reply-To: <CA+V-a8sW+D8trces5AXu__Lw9F7TO6fCcQW+LGZKRhA41uOEfw@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2013 07:09 PM, Prabhakar Lad wrote:
[...]
>>> diff --git a/Documentation/devicetree/bindings/media/i2c/tvp7002.txt
>>> b/Documentation/devicetree/bindings/media/i2c/tvp7002.txt
>>> new file mode 100644
>>> index 0000000..9daebe1
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/media/i2c/tvp7002.txt
>>> @@ -0,0 +1,43 @@
>>> +* Texas Instruments TV7002 video decoder
>>> +
[...]
>>> +
>>> +- ti,tvp7002-fid-polarity: Active-high Field ID polarity of the endpoint.
>>
>> I thought it was agreed 'field-even-active' would be used instead of
>> this device specific property. Did you run into any issues with that ?
>>
>>
> Argh I some how missed it out, sorry this should be 'field-even-active'

OK.

>> And include/media/tvp70002.h:
>>
>>   * fid_polarity:
>>   *                      0 ->  the field ID output is set to logic 1 for an
>> odd
>>   *                           field (field 1) and set to logic 0 for an even
>>   *                           field (field 0).
>>   *                      1 ->  operation with polarity inverted.
>>
>>
>> Do you know if the chip automatically selects video sync source
>> (sync-on-green
>> vs. VSYNC/HSYNC) and there is no need to configure this on the analogue
>> input
>> side ? At least the driver seems to always select the default SOGIN_1 input
>> (TVP7002_IN_MUX_SEL_1 register is set only at initialization time).
>>
> Yes the driver is selecting the default SOGIN_1 input.
>
>> Or perhaps it just outputs on SOGOUT, VSOUT, HSOUT lines whatever is fed to
>> its analogue inputs, and any further processing unit need to determine what
>> synchronization signal is present and should be used ?
>>
>
> Yes that correct, there is a register (Sync Detect Status) which
> detects the sync for you.
>
>> I suspect that we don't need, e.g. another endpoint node to specify the
>> configuration of the TVP7002 analogue input interface, that would contain
>> a property like video-sync.
>>
>>
> If I understand correctly you mean if there are two tvp7002 devices connected
> we don’t need to specify video-sync property, but my question how do we
> specify this property in common then ?

No, I thought about two port sub-nodes of a single device node, one for the
TVP7002 video input and one for the output. But it seems there is no need
for that, i.e. to specify the input configuration statically in the 
firmware.
The chip detects the signals automatically, i.e. it uses whatever is 
available,
and it allows querying the selection status at run time. What would really
need to be configured statically in DT in that case then ? Some initial 
video
sync configuration ? I guess it could be well hard coded in the driver, 
since
the hardware does run time detection anyway.

It there are real use cases I gues we could add video-sync property or 
similar,
besides the existing signal polarity properties.

--
Thanks,
Sylwester
