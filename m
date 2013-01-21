Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab3AUOdD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 09:33:03 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:56128 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab3AUOdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 09:33:00 -0500
MIME-Version: 1.0
In-Reply-To: <2462618.rQxKXSuBtr@vostro.rjw.lan>
References: <CAPPqfY1-sYT8rcPoJ6BD0axq=oczq+xbGFSQj=uth4wc_cvkGw@mail.gmail.com>
	<1396763.8sOcKf8eSO@vostro.rjw.lan>
	<CAPPqfY0-dEnm5JnTo=6ybTjv+A-1uz=ZRR4zcU5sPs+jBxbhLQ@mail.gmail.com>
	<2462618.rQxKXSuBtr@vostro.rjw.lan>
Date: Mon, 21 Jan 2013 15:26:10 +0100
Message-ID: <CAPPqfY3vZX3a-GONmzoWdn7sp=_pzKL2qAKBxYZ9ABNLetKoag@mail.gmail.com>
Subject: Re: Performance issue since 3.2.6
From: Olivier Doucet <webmaster@ajeux.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> FYI, I benchmarked a new version with :
>> CONFIG_PM_RUNTIME=y
>> CONFIG_PM=y
>>
>> but the performance loss is still present.
>
> In that case it is not quite likely that the commit you bisected to
> really introduced the problem, because it doesn't change things for
> CONFIG_PM=y.
>
> Does reverting that commit still help?

I tested several combinations. Results follows :
3.2.6 (base) + CONFIG_PM unset  => BAD
3.2.6 (base) + CONFIG_PM=y  => BAD
3.2.6 (base) + patch reverted + CONFIG_PM=y  => BAD
3.2.6 (base) + patch reverted + CONFIG_PM unset  => GOOD

So if I understand right, the targeted patch introduced the bug when
CONFIG_PM is unset, but there is an other bug when this var is set.
I'll try to track this commit.

Olivier
