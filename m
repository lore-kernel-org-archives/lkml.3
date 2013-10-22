Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab3JVMuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 08:50:24 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34692 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753639Ab3JVMuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 08:50:20 -0400
Message-ID: <1382446213.7734.18.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH v2 01/23] crypto: provide single place for hash algo
 information
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-security-module@vger.kernel.org,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>
Date: Tue, 22 Oct 2013 08:50:13 -0400
In-Reply-To: <20131022120704.GA9375@gondor.apana.org.au>
References: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1382395388-8108-2-git-send-email-zohar@linux.vnet.ibm.com>
	 <20131022052458.GA5896@gondor.apana.org.au>
	 <CACE9dm_Qvf5YaVvxDiDTMfAzZPA0hfqHOTxmvzUeEXCePUdJ2g@mail.gmail.com>
	 <20131022113203.GA8965@gondor.apana.org.au>
	 <CACE9dm-m4f7LYuTADmn_upUEoMjDUKMTBXdnKT=9j+RiqWSp4Q@mail.gmail.com>
	 <20131022120704.GA9375@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102212-7182-0000-0000-000008D716EC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-22 at 20:07 +0800, Herbert Xu wrote:
> On Tue, Oct 22, 2013 at 12:57:02PM +0100, Dmitry Kasatkin wrote:
> > On Tue, Oct 22, 2013 at 12:32 PM, Herbert Xu
> > <herbert@gondor.apana.org.au> wrote:
> > > On Tue, Oct 22, 2013 at 12:29:56PM +0100, Dmitry Kasatkin wrote:
> > >>
> > >> We are not adding user-space interface.
> > >> We just need to algo definitions which are in sync between user space,
> > >> IMA/EVM and kernel module signing.
> > >> Module signing perl script uses hard coded values. We want to improve
> > >> it export them to user space.
> > >>
> > >> But please give us a hint, what crypto user-space API helps for us?
> > >
> > > OK, if you're not exporting the kernel asymmetric key code then
> > > that's fine.
> > 
> > Can we take this to mean acked-by you?
> 
> FWIW I'm against introducing new interfaces using integer IDs
> for crypto algorithms.  Especially if such an interface is exposed
> to user-space.
> 
> You said that you're not currently using this as a kernel/user-space
> interface, which I can live with grudgingly.

> However, the fact that you've placed this file in uapi leads me to
> believe that at some future point in time there will be some sort
> of kernel/user-space interface using this.  Why else would they need
> to be in sync?

Files, including kernel modules, are already signed in userspace and
verified by the kernel.  So they already need to be in sync.  Up to now,
IMA was limited to a 20 byte digest.  This patch set adds support in IMA
for larger digests.

thanks,

Mimi

