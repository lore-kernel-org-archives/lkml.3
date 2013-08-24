Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab3HXUhg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 16:37:36 -0400
Received: from nm23-vm5.access.bullet.mail.gq1.yahoo.com ([216.39.63.141]:47850
	"EHLO nm23-vm5.access.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755638Ab3HXUhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 16:37:35 -0400
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Aug 2013 16:37:35 EDT
X-Yahoo-Newman-Id: 349413.86358.bm@smtp116.sbc.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: WPJLG8gVM1kipjwROVVVTubylrnPtuzdIPdqABn9K9PbaMO
 kUIsyI96wWdtOMWOuY_HFRL0AVdfE77ZSzYCQ6nu4RwTDtWlA1aut9o9_IUf
 H8oLPhUP5b7ZjLG6ao.FG5qdzsAWteUcqXzsBAV0cs7RahuNeRGGNpU4DI..
 4TV3iy2NusI91BxpFSAGbZYq4w.r1WMnQ8uNpN.uEHjE64ofNFYQDS5SsydP
 emvMFZaj7X6TaEeNYDLC.qb0hPbLF6PjvDeJbFu0DnOdYY8AImCdw_vlz659
 JoP1Ye41djTOtZxRxXmLqP9oruaZ2jOk850VUPXQU9rWby9ky6EIjRre9StW
 qs7PX4gKPdf0ZdjXElhJaHVZ2xWvjWbEIu5T5q7Uiievsb8U91jr9TJ1bipG
 WfQdR3jteoeLS5m8pfduulFKvzQN3ba3C__g9xaFrSfeFp8LLrdVR3lqI0pL
 rvxg33aRBwNhwsadgSxoIl5pFWgVDMkX7drIkyzNH2.t6M0K5qT5lku.1NQw
 ZYsIoP8n89PJk8S2Rcw--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
X-Rocket-Received: from [192.168.1.4] (danielfsantos@99.70.244.137 with plain)
        by smtp116.sbc.mail.ne1.yahoo.com with SMTP; 24 Aug 2013 20:31:50 +0000 UTC
Message-ID: <5219183F.8080300@att.net>
Date: Sat, 24 Aug 2013 15:31:59 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130730 Thunderbird/17.0.7
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Linus Walleij <linus.walleij@linaro.org>,
        linux-gpio <linux-gpio@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpiolib: Fix crash when exporting non-existant gpio
References: <1377370108-2867-1-git-send-email-daniel.santos@pobox.com> <52191041.7040505@roeck-us.net>
In-Reply-To: <52191041.7040505@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 08/24/2013 02:57 PM, Guenter Roeck wrote:
>
> Looking into calling code, desc_to_gpio() is clearly not supposed to 
> return an error,
> and it will result in odd behavior if it returns -1. For example, the 
> resulting debug
> message of "gpio--1 (...) status ..." is not very useful.
>
> It would make more sense to fix the calling code. You could for example
> validate in affected functions if the gpio pin exists by not only
> checking for desc but also for desc->chip. Another option might be
> to have gpio_to_desc() return NULL if desc->chip is NULL.

Yes, you are correct of course.  I guess I was just being lazy. :) I'll 
re-submit.

