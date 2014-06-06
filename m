Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbaFFWDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 18:03:54 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:60917 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbaFFWDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 18:03:52 -0400
MIME-Version: 1.0
In-Reply-To: <539017F0.1080503@acm.org>
References: <1401905288-32642-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<5390147F.8070803@acm.org>
	<539017F0.1080503@acm.org>
Date: Sat, 7 Jun 2014 00:03:52 +0200
Message-ID: <CAFo99gaO1P2nZK2y_KMFJASB4_-y9fk9kOZhtsZFz3jJGbiKSQ@mail.gmail.com>
Subject: Re: [PATCH] scsi: bfa: bfad_attr.c: Optimization of the Code
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Several have remarked in the other patch for strncpy I posted. That
there is a strlcpy that works exactly as one would like to strncpy was
done :)
And the return value is like for snprintf, but quite a lot faster!

So I submit patches based with it instead, and did a couple more
exchanges of snprintf to strlcpy.



Best regards
Rickard Strandqvist


2014-06-05 9:10 GMT+02:00 Bart Van Assche <bvanassche@acm.org>:
> On 06/05/14 08:55, Bart Van Assche wrote:
>> On 06/04/14 20:08, Rickard Strandqvist wrote:
>> This is ugly. Please use sprintf(buf, "%.*s\n", PAGE_SIZE - 1, str)
>> instead of strncpy() + strlen().
>
> (replying to my own e-mail)
>
> The above should of course have read "sprintf(buf, "%.*s\n", PAGE_SIZE -
> 2, str)" to avoid that the terminating '\0' triggers a buffer overflow.
>
> Bart.
