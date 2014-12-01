Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbaLAN7F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 08:59:05 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:19926 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852AbaLAN7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 08:59:00 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-0e-547c7421af3f
Message-id: <547C7420.4080801@samsung.com>
Date: Mon, 01 Dec 2014 14:58:56 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, cooloney@gmail.com, rpurdie@rpsys.net,
        sakari.ailus@iki.fi, s.nawrocki@samsung.com
Subject: Re: [PATCH/RFC v8 02/14] Documentation: leds: Add description of LED
 Flash class extension
References: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
 <1417166286-27685-3-git-send-email-j.anaszewski@samsung.com>
 <20141129125832.GA315@amd> <547C539A.4010500@samsung.com>
 <20141201130437.GB24737@amd>
In-reply-to: <20141201130437.GB24737@amd>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t/xy7qKJTUhBnP/a1hsnLGe1eLozolM
	Fmeb3rBbXN41h81i65t1jBY9G7ayWtw9dZTNYveup6wWh9+0s1qc2b+SzYHLY+esu+weh78u
	ZPHYM/8Hq0ffllWMHitWf2f3+LxJLoAtissmJTUnsyy1SN8ugSvjwMp9LAUzuSqmTZ3L1MDY
	xdHFyMkhIWAi8e/5PWYIW0ziwr31bF2MXBxCAksZJf6f3MIC4XxklJjyuJMdpIpXQEtia8tK
	FhCbRUBVYsK/JWBxNgFDiZ8vXjOB2KICERJ/Tu9jhagXlPgx+R5YvYiAvMTWvhXMIEOZBV4w
	Ssx4B7KOk0NYIFXizZt/jCC2kMAjRok5c6tBbE4BTYm1jw6ANTMLWEusnLSNEcKWl9i85i3z
	BEaBWUh2zEJSNgtJ2QJG5lWMoqmlyQXFSem5RnrFibnFpXnpesn5uZsYIRHxdQfj0mNWhxgF
	OBiVeHg111aHCLEmlhVX5h5ilOBgVhLhZS2oCRHiTUmsrEotyo8vKs1JLT7EyMTBKdXAKPL6
	4VOmFau2V2fwTshXfMRpWunWUbtZ6dhi7SU5T2PqptXtKf/Xt/zPxjNvH1kHLXHby9mqI39+
	84n8M+wlyznVP2x7LBKpo564buf8Y9eqr8zSO/JUdH278/JqlWpvt1Mh9t53FrMyPpy1b75A
	p5p7yZk1RYdcWlkD35snSRabx88LX7e4WomlOCPRUIu5qDgRAHyIHmtmAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On 12/01/2014 02:04 PM, Pavel Machek wrote:
> Hi!
>
>>> How are faults cleared? Should it be list of strings, instead of
>>> bitmask? We may want to add new fault modes in future...
>>
>> Faults are cleared by reading the attribute. I will add this note.
>> There can be more than one fault at a time. I think that the bitmask
>> is a flexible solution. I don't see any troubles related to adding
>> new fault modes in the future, do you?
>
> I do not think that "read attribute to clear" is good idea. Normally,
> you'd want the error attribute world-readable, but you don't want
> non-root users to clear the errors.

This is also V4L2_CID_FLASH_FAULT control semantics.
Moreover many devices clear the errors upon reading register.
I don't see anything wrong in the fact that an user can clear
an error. If the user has a permission to use a device then
it also should be allowed to clear the errors.

> I am not sure if bitmask is good solution. I'd return space-separated
> strings like "overtemp". That way, there's good chance that other LED
> drivers would be able to use similar interface...

The format of a sysfs attribute should be concise.
The error codes are generic and map directly to the V4L2 Flash
error codes.

Best Regards,
Jacek Anaszewski
