Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab3LSPe7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:34:59 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:41106 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab3LSPe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:34:58 -0500
Date: Thu, 19 Dec 2013 16:34:53 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        eranian@google.com, dsahern@gmail.com, adrian.hunter@intel.com,
        mingo@redhat.com, paulus@samba.org, a.p.zijlstra@chello.nl,
        Pekka Enberg <penberg@iki.fi>
Subject: Re: [PATCH 0/4] Add support of guest user space symbols for perf kvm
 command.
Message-ID: <20131219153453.GA20044@gmail.com>
References: <cover.1387493396.git.yangds.fnst@cn.fujitsu.com>
 <20131219141232.GM4819@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131219141232.GM4819@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> Em Thu, Dec 19, 2013 at 05:54:50PM -0500, Dongsheng Yang escreveu:
> > Hi all,
> > 	This patch add support of guest user space symbols for perf kvm command.
> 
> Cool stuff! Please see some comments on the patches, with requests for
> possible patch splits and better changeset comments.
>  
> > Example:
> >         # perf kvm --guestmount /tmp/guestmount/ top
> >         Samples: 1K of event 'cycles', Event count (approx.): 259112905

Btw., having to specify a '--guestmount /tmp/guestmount/' just to 
achieve a natural feature (proper guest symbol resolution) is a poor 
user interface, obviously.

Is there perhaps a predictable pattern as to where qemu (or libvirt) 
puts a user's guest mounts, or some other discovery method?

If yes then it would be possible to automatically look for that 
pattern, and use the guest filesystem when it's available, without the 
user having to manually configure the path.

( Ideally we'd have kernel help for discovering this, but last time I
  raised that with the KVM folks there was resistence. )

Thanks,

	Ingo
