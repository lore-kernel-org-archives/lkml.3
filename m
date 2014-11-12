Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbaKLCGv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:06:51 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:46922 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275AbaKLCGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 21:06:49 -0500
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F3292A157@ORSMSX114.amr.corp.intel.com>
References: <c2522bcacf5db9a25a819a8756502edb1d2ca10f.1415739239.git.luto@amacapital.net>
	<20141111213628.GP31490@pd.tnic>
	<CALCETrU-Uiv8zHC1_-agcH-ByLqzeN1c58EPue5AdbmaDQLpdQ@mail.gmail.com>
	<20141111223316.GQ31490@pd.tnic>
	<CALCETrW0+5FkYn-5=WH1vGc-KnRaSj5w83Ds7R9ZTqFX3hQ+5g@mail.gmail.com>
	<20141111230926.GR31490@pd.tnic>
	<CALCETrU+Sq=rW-p2OnjLiaSLqu8rTgbC9uTcqZBJ+J8JhNxa7Q@mail.gmail.com>
	<3908561D78D1C84285E8C5FCA982C28F3292A03B@ORSMSX114.amr.corp.intel.com>
	<CALCETrUU3vSLBVMpsma=8OqOZLRKUYBM19_94tkeZ7aWCEyhog@mail.gmail.com>
	<3908561D78D1C84285E8C5FCA982C28F3292A157@ORSMSX114.amr.corp.intel.com>
Date: Tue, 11 Nov 2014 18:06:48 -0800
X-Google-Sender-Auth: 6m9ZEsNTv2ej7jhaS59fJFb8EWw
Message-ID: <CA+8MBbJy3QziFGDzOxMrweWEe_yneETuo4O8bTPZg=2y15qdkQ@mail.gmail.com>
Subject: Re: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from userspace
From: Tony Luck <tony.luck@intel.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Innocent bystanders have RIPV=1, EIPV=0 in MCG_STATUS ... so they
> are quite easy to spot.

Bother ... except for the SRAO cases where *everyone* is an innocent
bystander - but someone should go look for the error and queue up
a page offline event.  Perhaps for this we'd do the self-ipi trick and
then scan the banks to look for SRAO signatures to process as well
as clearing MCIP

-Tony
