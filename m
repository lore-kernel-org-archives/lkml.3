Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab3LCOrB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:47:01 -0500
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:49272 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab3LCOrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:47:00 -0500
Subject: Re: [PATCH 1/6] GenWQE PCI support, health monitoring and recovery
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de
In-Reply-To: <20131203143010.GB3521@kroah.com>
References: <1383741943-14609-1-git-send-email-haver@linux.vnet.ibm.com>
	 <1383741943-14609-2-git-send-email-haver@linux.vnet.ibm.com>
	 <20131127191658.GA28409@kroah.com>
	 <1386077717.12186.7.camel@oc7383187364.ibm.com>
	 <20131203143010.GB3521@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Tue, 03 Dec 2013 15:46:51 +0100
Message-ID: <1386082011.29309.2.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120314-6892-0000-0000-00000717CE51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 03.12.2013, 06:30 -0800 schrieb Greg KH:
> On Tue, Dec 03, 2013 at 02:35:17PM +0100, Frank Haverkamp wrote:
> > > > +/* common struct for chip image exchange */
> > > > +struct chip_bitstream {
> > > > +	uint8_t __user *pdata;		/* pointer to image data     */
> > > > +	int	 size;			/* size of image file	     */
> > > 
> > > I think this fails the 32/64bit issue, right?
> > 
> > Yes. I replaced those by something like
> >    __u32 data_addr;
> > I hope that is fixing the 32/64bit issue.
> 
> No, not at all, how are you going to put a 64bit userspace pointer in
> there?
> 

Ohh, sorry __u64 of course:

/* common struct for chip image exchange */
struct genwqe_bitstream {
        __u64 data_addr;                /* pointer to image data */
        __u32 size;                     /* size of image file */
        __u32 crc;                      /* crc of this image */
        __u8  partition;                /* '0', '1', or 'v' */
        __u64 target_addr;              /* starting address in Flash */
        __u8  uid;                      /* 1=host/x=dram */

        __u64 slu_id;                   /* informational/sim: SluID */
        __u64 app_id;                   /* informational/sim: AppID */

        __u16 retc;                     /* returned from processing */
        __u16 attn;                     /* attention code from
processing */
        __u32 progress;                 /* progress code from processing
*/
};

and than I do in my userspace application:

        load.data_addr = (unsigned long)buf;

Is that ok, or must I consider more?

Regards

Frank


