Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383AbaJON6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 09:58:42 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:64923 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaJON6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 09:58:41 -0400
MIME-Version: 1.0
In-Reply-To: <20141015111641.GC7792@gaast.net>
References: <54347520.3050109@gaast.net> <543AA2FE.20105@gaast.net>
 <20141012204032.GA11171@amd> <9751497.0fL0kvsyX7@vostro.rjw.lan> <20141015111641.GC7792@gaast.net>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 15 Oct 2014 07:58:20 -0600
Message-ID: <CAErSpo5A+nHTu2Y6KrXowBBCBsNw_hO0SRsnc6YRdJChCUmO6w@mail.gmail.com>
Subject: Re: Machine crashes right *after* ~successful resume
To: Wilmer van der Gaast <wilmer@gaast.net>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Yinghai, author of 928bea964827 ("PCI: Delay enabling bridges
until they're needed")]

On Wed, Oct 15, 2014 at 5:16 AM, Wilmer van der Gaast <wilmer@gaast.net> wrote:
> Hello Rafael,
>
> Rafael J. Wysocki (rjw@rjwysocki.net) wrote:
>> > Would it be feasible to revert 2e8b... to see if it fixes it on 3.17?
>> That's a merge, isn't it?
>>
> Correct, it was, and I did try to figure out which of its parents was
> the guilty one, but then I found out the real problem is
> 928bea964827d7824b548c1f8e06eccbbc4d0d7d.
>
> Not sure why 2e8b... was initially found guilty by git bisect, I fear
> that my testing was not thorough enough. I've verified a couple of times
> now that 928bea96... does cause crashes and the previous revision does not.
>
> 928bea... seems to reshuffle PCI initialisation a little bit and has
> caused more troubles, judging from a Google query for it. Some changes
> were made already as a result, and this unfortunately makes a revert on
> a later kernel tree (to see if that fixes the problem for me) much less
> straight-forward. :-(

More details (from initial post) here: http://roy.gaast.net/~wilmer/.lkml/

Can you open a report at http://bugzilla.kernel.org, please?  Please
also attach the complete "lspci -vv" output.

Bjorn
