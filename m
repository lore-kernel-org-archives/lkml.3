Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759413Ab3BWVhk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 16:37:40 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:63409 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758649Ab3BWVhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 16:37:39 -0500
MIME-Version: 1.0
In-Reply-To: <20130223194300.GA13174@konrad-lan.dumpdata.com>
References: <alpine.DEB.2.02.1302221929040.22997@kaball.uk.xensource.com>
	<5127CE65.5010703@linux.intel.com>
	<CAE9FiQXHHFb0W+aJCsefRNj4p+X1+m8JOLUDz74w-nAjnhym+A@mail.gmail.com>
	<5127DDB3.2010309@zytor.com>
	<CAE9FiQWctM60VwXJYtOXwPBNLUoz966Fr1g6MPsPoJBiye88YQ@mail.gmail.com>
	<5127FBA4.1040506@zytor.com>
	<20130223003738.GA23545@phenom.dumpdata.com>
	<CAE9FiQVTbDkvU8KQGVoYv3kn6UeCTcdiPA2hvw21OKtNbM=XKg@mail.gmail.com>
	<20130223012716.GA28377@phenom.dumpdata.com>
	<CAE9FiQUcJiDOjv-XYYUfQAAHaZCq2Q1heR5YakGf13SYJjxyxA@mail.gmail.com>
	<20130223194300.GA13174@konrad-lan.dumpdata.com>
Date: Sat, 23 Feb 2013 13:37:38 -0800
X-Google-Sender-Auth: MDhjXITBxQy0Q1PvhwFzpbgen-k
Message-ID: <CAE9FiQVPwD14j2FGyW9NZqXqo1MyaP0M9mGcirAWo=hM8fP_Lg@mail.gmail.com>
Subject: Re: [GIT PULL] x86/mm changes for v3.9-rc1
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 23, 2013 at 11:43 AM, Konrad Rzeszutek Wilk
<konrad@kernel.org> wrote:
>> >> Also you should check condition about calling xen_get_user_pgd().
>> >
>> > Could you elaborate please?
>>
>> only call xen_get_user_pgd() when it should be called.
>
> I should have been more explicit. When I was saying "elaborate" I was
> soliciting for advice on the 'check condition' and how to make it robust.

your 64bit xen_write_cr3_init, is just xen_write_cr3 without
xen_get_user_pgd calling.
plus set xen_write_cr3 to ops.write_cr3.

so if you could have way to find out when xen_get_user_pgd could be used,
new xen_write_cr3_init need to check that, then set ops.write_cr3 and
call ops.write_cr3
otherwise will still call slim version without update ops.write_cr3
and bail out early.

Thanks

Yinghai
