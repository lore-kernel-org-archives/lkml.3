Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbaFJUsi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:48:38 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:57511 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbaFJUsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 16:48:37 -0400
MIME-Version: 1.0
In-Reply-To: <20140610065735.GF5500@mwanda>
References: <1401917989-3427-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20140610065735.GF5500@mwanda>
Date: Tue, 10 Jun 2014 22:48:35 +0200
Message-ID: <CAFo99gY9ROmVS56PeeAPxw6GgBnjLai3az0ABnE=1xcryDCRuA@mail.gmail.com>
Subject: Re: [PATCH] staging: usbip: stub_main.c: Cleaning up missing
 null-terminate after strncpy call
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        devel@driverdev.osuosl.org, linux-usb@vger.kernel.org,
        navin patidar <navinp@cdac.in>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

True!
Sorry  :-(

But then one would either operate strcpy outright.

Or use strlcpy then the code would be:

    /* strlcpy() handles not include \0 */
    len = strlcpy(busid, buf + 4, BUSID_SIZE);

    /* busid needs to include \0 termination */
    if (!(len < BUSID_SIZE))
        return -EINVAL;


Or should we just let it be, perhaps?


Kind regards
Rickard Strandqvist


2014-06-10 8:57 GMT+02:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Wed, Jun 04, 2014 at 11:39:49PM +0200, Rickard Strandqvist wrote:
>> Added a guaranteed null-terminate after call to strncpy.
>>
>> This was partly found using a static code analysis program called cppcheck.
>>
>
> We already knew that the string was NUL terminated because we checked
> strnlen() on the lines before.
>
> regards,
> dan carpenter
>
