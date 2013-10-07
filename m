Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab3JGB56 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 21:57:58 -0400
Received: from nm16.bullet.mail.bf1.yahoo.com ([98.139.212.175]:28862 "EHLO
	nm16.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754091Ab3JGB5w convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 21:57:52 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 111077.13262.bm@omp1041.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=WKzJv8T/i1MmaSZWPxBPL6zRNcuBn5yTiG1rIkCMLPYKQfQHZm2QSCQDKuLwpPlIEESkRSK+0RkoGQxUb5Rrklty/wFhBB7z/K+FIJAMDGPJDZRGb14nJpvMm6ag6xwXaklCRRyv/HNACWoUTtgRh+kb9v9uh+xqpTKEvGvh/x0=;
X-YMail-OSG: Vdbln9oVM1mvkCYByfcm1M7amYY8R0UOj7QUz1Z0oPgJVfE
 oWXgACGmZjidflX5eDZwEukdU47cI.CjVq3Wyl..5aUCW0SD8eYKZn9CrHjG
 A_vbNwevRbMT6p4RVDR6HJZoCPvP66d6n47hY4OwyVB.HZTSAOn70aNjMD5j
 sQFguKpMETMDtzZHkYgcgSXVITdYqsFWbHvmDqPkhMvQ9ixhoWppXLPbGe_d
 nsdffiAfXZoG2zFGAxaAif2dGT_6BK8lmmZYSg0qM6Y7NOyBDID5MNf3qfUk
 Q7mp5fmevvT3g1eKs71fKZnoPHTMhoeP4zlDzHa2R_Bj1iLUs6UAIA7PseHs
 oKHEjCNhYA0LBO.SzAXDq_9tKeyOsipVExgQ8nI3.52RhepyTnrZDsqTF65h
 tOIXycUOhQltOPBifsYjdc2vL90WvI69ucUJyK_ALHa3VvpyTfMSoyaJRaLI
 RZARuJ3BwwiWeyG0rBQdxsrWjtr3nwM9uWy39ky6_ebBrF0QOUvjV6QatnLj
 kAwsSu_3IYOG.cuo6xX8nCoNHDt_MfqS4tSApsD6W5NQ2bMEMfkjFiO4qWv1
 WFXEaPmqOWoseAaKfSLt2_g.SWjVOD4.f2Rsz8AcWyGX1Vhxt7bJIcUVqGvV
 VpDjCDhQrPGP64GpfJB2NNGwAr8r6MWsFSiYqQyCVltgW_wmL
X-Rocket-MIMEInfo: 002.001,SGksCgpJbiB0aGUgZ29vZCBvbGQgdGltZXMsIHdoZW4gdGhpcyBkcml2ZXIgd2FzIGZpcnN0IHdyaXR0ZW4sIGRldmljZSBuYW1lIHVzZWQgdG8gYmUgYSBmaXhlZApzaXplIGFycmF5IChvZiAzMiBjaGFycywgaWYgSSdtIG5vdCBtaXN0YWtlbikgaW4gdGhlIGtvYmogc3RydWN0LCBzbyB0aGVyZSB3YXMgbm8gbmVlZCB0bwpmcmVlIGl0IGV4cGxpY2l0bHkuCgpTaW5jZSB0aGFuLCBzb21lYm9keSBjaGFuZ2VkIHRoZSBuYW1lIGZpZWxkIHRvIGJlY29tZSBhIGxvb3NlIHBvaW50ZXIsIGJ1dCBpdCdzIG5vdAoBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.160.587
References: <1380834798-5829-1-git-send-email-Larry.Finger@lwfinger.net> <CAHkRjk4MUOcXE6QngJYDcD1-1GMERxTusNcHr0FciU=wfFxbYA@mail.gmail.com> <5251FA23.1080504@lwfinger.net>
Message-ID: <1381111070.35370.YahooMailNeo@web161301.mail.bf1.yahoo.com>
Date: Sun, 6 Oct 2013 18:57:50 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Reply-To: Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH] memstick: Fix memory leak in memstick_check() error path
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Catalin Marinas <catalin.marinas@arm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <5251FA23.1080504@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In the good old times, when this driver was first written, device name used to be a fixed
size array (of 32 chars, if I'm not mistaken) in the kobj struct, so there was no need to
free it explicitly.

Since than, somebody changed the name field to become a loose pointer, but it's not
obvious how it is supposed to be handled these days.




________________________________
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Catalin Marinas <catalin.marinas@arm.com> 
Cc: Alex Dubov <oakad@yahoo.com>; Linux Kernel Mailing List <linux-kernel@vger.kernel.org>; Kay Sievers <kay.sievers@vrfy.org>; Greg Kroah-Hartman <gregkh@suse.de> 
Sent: Monday, 7 October 2013 11:02 AM
Subject: Re: [PATCH] memstick: Fix memory leak in memstick_check() error path


On 10/04/2013 03:54 AM, Catalin Marinas wrote:
> On 3 October 2013 22:13, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> diff --git a/drivers/memstick/core/memstick.c b/drivers/memstick/core/memstick.c
>> index ffcb10a..0c73a45 100644
>> --- a/drivers/memstick/core/memstick.c
>> +++ b/drivers/memstick/core/memstick.c
>> @@ -415,6 +415,7 @@ static struct memstick_dev *memstick_alloc_card(struct memstick_host *host)
>>          return card;
>>   err_out:
>>          host->card = old_card;
>> +       kfree(card->dev.kobj.name);
>
> It looks weird to go into dev.kobj internals here for freeing the
> name. There is also memstick_free_card() which doesn't seem to do
> anything about the name freeing.
>
> Should memstick_alloc_card() do a device_initialise(&card->dev) and in
> memstick_free_card() (or the error path) do a put_device(&card->dev)?
> This should take care of kobj.name as well via kobject_put().

I tried several code changes that included adding a device_initialize() call, 
but all of them oopsed even when I followed the examples in other drivers. 
Adding a put_device() without the device_initialize() did not oops, but it still 
leaked the name.

We could avoid going into the dev.kobj internals if a device_free_name() routine 
existed as a companion to dev_set_name().


Larry
