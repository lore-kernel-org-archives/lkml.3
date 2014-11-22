Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833AbaKVN4W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 08:56:22 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:49321 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbaKVN4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 08:56:20 -0500
Message-ID: <54709601.9040606@colorfullife.com>
Date: Sat, 22 Nov 2014 14:56:17 +0100
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>, Davidlohr Bueso <dave@stgolabs.net>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Rafael Aquini <aquini@redhat.com>
Subject: Re: [PATCH] ipc,sem block sem_lock on sma->lock during sma initialization
References: <20141121145226.2ac598af@annuminas.surriel.com>	 <20141121120930.3cd8d0f233f9670d689de672@linux-foundation.org>	 <546FA0A7.2010507@redhat.com>	 <20141121124229.933a9b6ef9725a4032c95d45@linux-foundation.org>	 <546FC4D9.6010600@redhat.com> <1416617795.17594.14.camel@linux-t7sj.site> <547005A0.8020208@redhat.com>
In-Reply-To: <547005A0.8020208@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rik,

good catch - I completely forgot to check the initialization

On 11/22/2014 04:40 AM, Rik van Riel wrote:
>
> newary initializes a bunch of things after the call to
> ipc_addid, however some things are initialized inside
> ipc_addid as well
>
> Looking closer at newary, I suppose that it should be
> possible to move those other initializations before
> the call to ipc_addid.  That would likely get rid of
> the problem, too.
>
> However, I also see this line in newary, and I have
> no idea what protects that data:
>
>          ns->used_sems += nsems;
It should be sem_ids.rwsem, and at least according to the documentation 
both freeary() and newary() hold it.


--
     Manfred
