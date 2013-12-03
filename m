Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab3LCO32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:29:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48565 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab3LCO3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:29:08 -0500
Date: Tue, 3 Dec 2013 06:30:10 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Frank Haverkamp <haver@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de
Subject: Re: [PATCH 1/6] GenWQE PCI support, health monitoring and recovery
Message-ID: <20131203143010.GB3521@kroah.com>
References: <1383741943-14609-1-git-send-email-haver@linux.vnet.ibm.com>
 <1383741943-14609-2-git-send-email-haver@linux.vnet.ibm.com>
 <20131127191658.GA28409@kroah.com>
 <1386077717.12186.7.camel@oc7383187364.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386077717.12186.7.camel@oc7383187364.ibm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 02:35:17PM +0100, Frank Haverkamp wrote:
> > > +/* common struct for chip image exchange */
> > > +struct chip_bitstream {
> > > +	uint8_t __user *pdata;		/* pointer to image data     */
> > > +	int	 size;			/* size of image file	     */
> > 
> > I think this fails the 32/64bit issue, right?
> 
> Yes. I replaced those by something like
>    __u32 data_addr;
> I hope that is fixing the 32/64bit issue.

No, not at all, how are you going to put a 64bit userspace pointer in
there?

