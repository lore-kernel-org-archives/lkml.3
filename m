Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbaKVPxe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 10:53:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbaKVPxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 10:53:33 -0500
Message-ID: <5470B170.90007@redhat.com>
Date: Sat, 22 Nov 2014 10:53:20 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>,
        Davidlohr Bueso <dave@stgolabs.net>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Rafael Aquini <aquini@redhat.com>
Subject: Re: [PATCH] ipc,sem block sem_lock on sma->lock during sma initialization
References: <20141121145226.2ac598af@annuminas.surriel.com>	 <20141121120930.3cd8d0f233f9670d689de672@linux-foundation.org>	 <546FA0A7.2010507@redhat.com>	 <20141121124229.933a9b6ef9725a4032c95d45@linux-foundation.org>	 <546FC4D9.6010600@redhat.com> <1416617795.17594.14.camel@linux-t7sj.site> <547005A0.8020208@redhat.com> <54709601.9040606@colorfullife.com>
In-Reply-To: <54709601.9040606@colorfullife.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/22/2014 08:56 AM, Manfred Spraul wrote:
> Hi Rik,
> 
> good catch - I completely forgot to check the initialization
> 
> On 11/22/2014 04:40 AM, Rik van Riel wrote:
>> 
>> newary initializes a bunch of things after the call to ipc_addid,
>> however some things are initialized inside ipc_addid as well
>> 
>> Looking closer at newary, I suppose that it should be possible to
>> move those other initializations before the call to ipc_addid.
>> That would likely get rid of the problem, too.
>> 
>> However, I also see this line in newary, and I have no idea what
>> protects that data:
>> 
>> ns->used_sems += nsems;
> It should be sem_ids.rwsem, and at least according to the
> documentation both freeary() and newary() hold it.

You're right, that is properly protected already.

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUcLFwAAoJEM553pKExN6DoGwIAJVr0SJWq1sxkRr6quw03OlU
8GUNm8Mz4tVpt1PYSe5r3SIGeT0btEhXjRrqp3IOw7z85Iw5Ed2CwzuLS3aunmpg
hZag9qyArxKBQkbnhtqiM/0AEHbRiju3+sFNC1cQxsdRvLV6QkRveoP5kKvv4v6d
PCMJBHuxL01tPXe5eQC2WjLmI2YPgWWh3fXhDcLt2XTVBI0vwyBiVFc/CtSPERo0
sBF01l/l5KRfOAHduW2kj7KrSF004IgLU7KN5fLG0BzvwlowcHjXgzX7mMCbZrm2
8d8bdEtRJxDZqs4Z9XjDrjXfSdWH/H/5CnfAmvgXA4pswb1lLDLPFbgmt7NUtxk=
=vUfd
-----END PGP SIGNATURE-----
