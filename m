Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbaFLVJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 17:09:22 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:39758 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbaFLVJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 17:09:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140611053612.GN5015@mwanda>
References: <1401917989-3427-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20140610065735.GF5500@mwanda>
	<CAFo99gY9ROmVS56PeeAPxw6GgBnjLai3az0ABnE=1xcryDCRuA@mail.gmail.com>
	<20140611053612.GN5015@mwanda>
Date: Thu, 12 Jun 2014 23:09:20 +0200
Message-ID: <CAFo99gbu5GxKSyDEfo+wpzHkjQdxqDhXF9irtCUcCNjFG2GUBQ@mail.gmail.com>
Subject: Re: [PATCH] staging: usbip: stub_main.c: Cleaning up missing
 null-terminate after strncpy call
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, navin patidar <navinp@cdac.in>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-06-11 7:45 GMT+02:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Tue, Jun 10, 2014 at 10:48:35PM +0200, Rickard Strandqvist wrote:
>> Hi
>>
>> True!
>> Sorry  :-(
>>
>> But then one would either operate strcpy outright.
>>
>> Or use strlcpy then the code would be:
>>
>>     /* strlcpy() handles not include \0 */
>>     len = strlcpy(busid, buf + 4, BUSID_SIZE);
>>
>>     /* busid needs to include \0 termination */
>>     if (!(len < BUSID_SIZE))
>
> I don't like this condition.  Just say (len >= BUSID_SIZE).  The
> comments here are obvious and could be left out.
>
>>         return -EINVAL;
>
> I don't have strong feelings about a cleanup patch.  But I think that
> cppcheck is not being very sofisticated here with the NUL termination
> warning so we should not go out of our way to try to silence the
> warning.
>
> regards,
> dan carpenter
>


Hi Dan

I agree that you should not do patches just to silence a static control program.

Concerning (len >= BUSID_SIZE) I agree! But I usually try to change as
little as possible in the patches I do. But perhaps I should not think
that way.



Kind regards
Rickard Strandqvist
