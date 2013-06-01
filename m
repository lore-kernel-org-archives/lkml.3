Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab3FAEvN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 00:51:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:53233 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427Ab3FAEvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 00:51:01 -0400
Message-ID: <1370062229.3766.28.camel@pasglop>
Subject: Re: [PATCH v3 5/8] powerpc/pseries: Read rtas partition via pstore
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>
Cc: linuxppc-dev@ozlabs.org, paulus@samba.org, linux-kernel@vger.kernel.org,
        jkenisto@linux.vnet.ibm.com, tony.luck@intel.com, ananth@in.ibm.com,
        mahesh@linux.vnet.ibm.com, ccross@android.com, anton@samba.org,
        cbouatmailru@gmail.com, keescook@chromium.org
Date: Sat, 01 Jun 2013 14:50:29 +1000
In-Reply-To: <1370062185.3766.27.camel@pasglop>
References: <20130425100952.21017.51799.stgit@aruna-ThinkPad-T420>
	 <20130425101851.21017.90041.stgit@aruna-ThinkPad-T420>
	 <1370062185.3766.27.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-06-01 at 14:49 +1000, Benjamin Herrenschmidt wrote:
> On Thu, 2013-04-25 at 15:48 +0530, Aruna Balakrishnaiah wrote:
> > This patch set exploits the pstore subsystem to read details of rtas partition
> > in NVRAM to a separate file in /dev/pstore. For instance, rtas details will be
> > stored in a file named [rtas-nvram-4].
> > 
>  .../...
> 
> > diff --git a/include/linux/pstore.h b/include/linux/pstore.h
> > index 75d0176..d7a8fe9 100644
> > --- a/include/linux/pstore.h
> > +++ b/include/linux/pstore.h
> > @@ -35,6 +35,8 @@ enum pstore_type_id {
> >  	PSTORE_TYPE_MCE		= 1,
> >  	PSTORE_TYPE_CONSOLE	= 2,
> >  	PSTORE_TYPE_FTRACE	= 3,
> > +	/* PPC64 partition types */
> > +	PSTORE_TYPE_PPC_RTAS	= 4,
> >  	PSTORE_TYPE_UNKNOWN	= 255
> >  };
> >  
> 
> Not sure about that list...
> 
> What do you mean by "RTAS" ? The error logs ? What about our "common"
> partition (firmware settings ?). We should probably at least define
> a generic PSTORE_TYPE_FIRMWARE for firmware private stuff...

Scrap it, I just noticed your next patch doing that,... see comment
there.

Cheers,
Ben.


