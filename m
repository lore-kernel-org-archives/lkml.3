Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab3AWPwW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 10:52:22 -0500
Received: from mail-vb0-f50.google.com ([209.85.212.50]:51578 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab3AWPwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 10:52:21 -0500
MIME-Version: 1.0
In-Reply-To: <CA+icZUVPDx=SkGFvYpACjoFE4NWchCJGs3ZnOVshs-a0dBYA3A@mail.gmail.com>
References: <1358946905-13320-1-git-send-email-sedat.dilek@gmail.com>
	<CAHdPZaNYFBXMhvH7Jyy5Zy4MnB3iKfL9UW9xf3jy5MNBu8aPnw@mail.gmail.com>
	<CA+icZUW7XrOGguoPO00wxPLUr2Xc8fP=jQZwekpnmWKRewwX2g@mail.gmail.com>
	<CAFTL4hzcuxoy2deQpXDBRQZZBZ4VjT=EnO3ZZv6x-jGMTr_eaA@mail.gmail.com>
	<1358949189.21576.114.camel@gandalf.local.home>
	<CAFTL4hzSvnE-b=TEvKcT3Jpwh4ZLPsMotCC7etpUeDDFNYOQBQ@mail.gmail.com>
	<CA+icZUXM+tj5hnh--3CraRsvrsKfBUrS7Udf2L1OEhBnvWqpjQ@mail.gmail.com>
	<CAFTL4hwkRv5LjzXN2BmSxS73GqKZkJ=H92qaD+ohvdOs-pAxHg@mail.gmail.com>
	<CA+icZUVPDx=SkGFvYpACjoFE4NWchCJGs3ZnOVshs-a0dBYA3A@mail.gmail.com>
Date: Wed, 23 Jan 2013 16:52:20 +0100
Message-ID: <CAFTL4hw=KpOrVw3sEMBQ8+2V79B4Bx1uPO8qvfmyXio+qA1v5w@mail.gmail.com>
Subject: Re: [PATCH 3.8-rc4-nohz3] kvm: Add missing EXPORT_SYMBOL when CONFIG_KVM=m
From: Frederic Weisbecker <fweisbec@gmail.com>
To: sedat.dilek@gmail.com
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "devendra.aaru" <devendra.aaru@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/23 Sedat Dilek <sedat.dilek@gmail.com>:
>> So CONFIG_SOMETHING doesn't work when it's a module. Hence we need to
>> remove the ifdef CONFIG_KVM around guest_enter(), guest_exit(),
>> vtime_guest_enter() and vtime_guest_exit(). Also it seems we need
>> <linux/export.h> in context_tracking.c
>
> You mean sth. like this?

Almost. vtime_guest_enter/exit don't need to be exported because they
are not referenced by module code: guest_enter/exit are builtin code.
