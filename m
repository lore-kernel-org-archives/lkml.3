Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbaJMADh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 20:03:37 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:58764 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbaJMADc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 20:03:32 -0400
Message-ID: <1413158605.14699.46.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [tpmdd-devel] [TrouSerS-tech] [Ksummit-discuss] TPM MiniSummit
 @ LinuxCon Europe
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Stefan Berger <stefanb@linux.vnet.ibm.com>, keyrings@linux-nfs.org,
        jarkko.sakkinnen@linux.intel.com,
        "ksummit-discuss@lists.linuxfoundation.org" 
	<ksummit-discuss@lists.linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        tpmdd-devel@lists.sourceforge.net,
        James Morris <james.l.morris@oracle.com>,
        linux-ima-devel@lists.sourceforge.net,
        trousers-tech@lists.sourceforge.net, Peter Huewe <PeterHuewe@gmx.de>
Date: Sun, 12 Oct 2014 20:03:25 -0400
In-Reply-To: <CALCETrVVSd_pTBP3ghn=oroNqrxPYRev-xcQ+KnF8kcZZiwB7A@mail.gmail.com>
References: <trinity-2d36367c-59c5-44af-8737-fb503e10af38-1411376491498@3capp-gmx-bs07>
	 <CALCETrWdPmSCUkb-neH5ssNmxzsqY0rioQq5qMc2ne7J0JxVLg@mail.gmail.com>
	 <543428E1.7050702@linux.vnet.ibm.com>
	 <20141007180209.GD10432@obsidianresearch.com>
	 <5434352A.6080403@linux.vnet.ibm.com>
	 <CALCETrVVSd_pTBP3ghn=oroNqrxPYRev-xcQ+KnF8kcZZiwB7A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14101300-0009-0000-0000-0000058D18DC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-07 at 11:59 -0700, Andy Lutomirski wrote: 
> On Tue, Oct 7, 2014 at 11:47 AM, Stefan Berger
> <stefanb@linux.vnet.ibm.com> wrote:
> > On 10/07/2014 02:02 PM, Jason Gunthorpe wrote:
> >>
> >> On Tue, Oct 07, 2014 at 01:54:41PM -0400, Stefan Berger wrote:
> >>
> >>> Why add the complexity of swapping of authenticated sessions and keys
> >>> into the kernel if you can handle this in userspace? You need a library
> >>> that is aware of the number of key slots and slots for sessions in the
> >>> TPM and swaps them in at out when applications need them. Trousers is
> >>> such a library that was designed to cope with the limitations of the
> >>> device and make its functionality available to all applications that
> >>> want to access it.
> >>
> >> How does trousers work with the kernel when the kernel is also using
> >> TPM key slots for IMA/keyring/whatever?
> >
> >
> > IIRC it only uses a single key slot and swaps all keys in and out of that
> > one. If the kernel was to fill up all key (and sessions) slots, TSS would
> > probably not work anymore.
> >
> > Another argument for the TSS is that you also wouldn't want applications to
> > swap out each others keys and sessions and leave them out or assume that
> > they would always cleanup if they do not currently need them.
> 
> That argument seems backwards.  If you're worried about applications
> (or trousers itself!) failing to clean up, then shouldn't the kernel
> driver clean up orphaned key slots itself?

As I understand it, this isn't an issue of "cleaning up", but of
mediating the limited resources, by "swapping" keys in and out as
needed.

Mimi

> Also, what protects the kernel from having slot 0 get stomped on or,
> worse, inappropriately used by a misbehaving or malicious user
> program?  Is the authorization session mechanism really secure against
> intentional abuse by users of the same machine?
> 
> --Andy

