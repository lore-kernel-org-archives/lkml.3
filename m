Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854AbaFCPCm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 11:02:42 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:33151 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250AbaFCPCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 11:02:40 -0400
Message-ID: <1401807754.5458.13.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [RFC PATCH v4 4/4] KEYS: define an owner trusted keyring
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Josh Boyer <jwboyer@redhat.com>
Cc: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        David Howells <dhowells@redhat.com>, keyrings <keyrings@linux-nfs.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 03 Jun 2014 11:02:34 -0400
In-Reply-To: <20140602115505.GA10515@hansolo.jdub.homelinux.org>
References: <1401289784-31340-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1401289784-31340-5-git-send-email-zohar@linux.vnet.ibm.com>
	 <CACE9dm-CwB=wPffdg7UMKWw1LBaePBgxXPYd9E51dZK+kpFKBw@mail.gmail.com>
	 <1401588848.22476.33.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <CACE9dm_9QQapE=NiPF+vL=RpuoVAFLotOyzObcRRZ=+rqeuCOw@mail.gmail.com>
	 <1401708833.15098.26.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <CACE9dm-bqp-a3yogxEDk3M1c-XByuYki+7jZK3=U=VtqDMkCRQ@mail.gmail.com>
	 <20140602115505.GA10515@hansolo.jdub.homelinux.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060315-1542-0000-0000-0000024C8A4A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-02 at 07:55 -0400, Josh Boyer wrote: 
> On Mon, Jun 02, 2014 at 02:40:28PM +0300, Dmitry Kasatkin wrote:
> > On 2 June 2014 14:33, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > > On Mon, 2014-06-02 at 13:48 +0300, Dmitry Kasatkin wrote:
> > >> On 1 June 2014 05:14, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> > > Currently only the builtin keys are on the system keyring, but once
> > > David and Josh's UEFI patches are upstreamed, the UEFI keys will also be
> > > on the system keyring.  At that point, we would want to differentiate
> > > between the builtin keys and the remaining keys on the system keyring.
> > > Splitting this patch definitely helps clarify what's happening and, more
> > > importantly, why.
> > >
> > > Mimi
> > >
> > 
> > Ok. May be would should focus on patches for existing functionality.
> > If something new comes from other side, it can be addressed by new
> > another set of patches.
> 
> I agree.  I appreciate taking the UEFI key patches into account, but
> they're held up and won't be hitting mainline in the next release or
> two.  Focus on the changes you need to make against mainline.

Ok.  I've rewritten the patch.  Instead of loading the key on the owner
keyring at the same time as loading it on the system keyring, it waits
until all the keys are on the system keyring, before adding the
specified key to the owner keyring.  We loose the ability to specify all
the builtin keys, but at least for now, this isn't important.  For now,
we can identify a single builtin key, and when the UEFI patches are
upstreamed, we should be able to identify a UEFI key, as well.

thanks,

Mimi

