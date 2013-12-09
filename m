Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760893Ab3LIIgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 03:36:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48273 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451Ab3LIIgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 03:36:13 -0500
Date: Mon, 9 Dec 2013 00:25:27 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Ethan Zhao <ethan.kernel@gmail.com>
Cc: konrad.wilk@oracle.com, raghavendra.kt@linux.vnet.ibm.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen/debugfs: Check debugfs initialization before using it
Message-ID: <20131209082527.GA26950@kroah.com>
References: <1386502262-1163-1-git-send-email-ethan.kernel@gmail.com>
 <20131208140100.GA22793@kroah.com>
 <CABawtvO5YxH8J3d9Ea2ya3UUCEwjPWBRJaCJJMfovgmtPPBcRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABawtvO5YxH8J3d9Ea2ya3UUCEwjPWBRJaCJJMfovgmtPPBcRQ@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 09:43:16AM +0800, Ethan Zhao wrote:
> On Sun, Dec 8, 2013 at 10:01 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Sun, Dec 08, 2013 at 07:31:02PM +0800, ethan.zhao wrote:
> >> Should check debugfs initialization with debugfs_initialized() before using it,
> >> Because if it isn't initialized, the return value of fake debugfs_create_dir() etc
> >> functions would be ERR_PTR(-ENODEV), checking with NULL will not work.
> >
> > So?  It should "just work" without this check, right?  What happens if
> > your patch isn't applied and debugfs isn't enabled?
> 
> If debugfs isn't  configured, debugfs_initialized() and other
> functions are defined as following,
> 
> static inline bool debugfs_initialized(void)
> {
> return false;
> }
> 
> static inline struct dentry *debugfs_create_file(const char *name, umode_t mode,
> struct dentry *parent, void *data,
> const struct file_operations *fops)
> {
> return ERR_PTR(-ENODEV);
> }
> 
> static inline struct dentry *debugfs_create_dir(const char *name,
> struct dentry *parent)
> {
> return ERR_PTR(-ENODEV);
> }
> 
> And the checking code in xen\debugfs.c xen_init_debugfs() will not
> work, the return value is not NULL.
> d_xen_debug = debugfs_create_dir("xen", NULL);
> 
> if (!d_xen_debug)
> pr_warning("Could not create 'xen' debugfs directory\n");

Which is just fine, what is wrong with this?

> >
> > greg k-h
> >
> >> Signed-off-by: ethan.zhao <ethan.kernel@gmail.com>
> >
> > Please put your "real" name here, not one with a '.' in it.
> 
> The real name used in company is ethan.zhao@oracle.com,  but I
> couldn't send and receive mails of
> community with that mailbox for some reason you may know.

I mean the "ethan.zhao" part, it should be "Ethan Zhao" :)

thanks,

greg k-h
