Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933239Ab3E3OzC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 10:55:02 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34097 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757900Ab3E3Oyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 10:54:51 -0400
Date: Thu, 30 May 2013 09:54:34 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: axboe@kernel.dk,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/8] rsxx: Adding in debugfs entries.
Message-ID: <20130530145434.GA3051@oc6784271780.ibm.com>
References: <20130528210833.GA5065@oc6784271780.ibm.com>
 <CAHp75VdFZmGEPXHQpW3YnvzXHqYsvo2-MhGk-p9itkZu7SnyUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VdFZmGEPXHQpW3YnvzXHqYsvo2-MhGk-p9itkZu7SnyUg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13053014-7182-0000-0000-00000705E672
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I will look into all of the suggestion that you submitted to me.

Thank you for taking the time to review the patches.

Regards,
-Philip Kelleher

On Wed, May 29, 2013 at 09:18:12PM +0300, Andy Shevchenko wrote:
> On Wed, May 29, 2013 at 12:08 AM, Philip J. Kelleher
> <pjk1939@linux.vnet.ibm.com> wrote:
> > From: Philip J Kelleher <pjk1939@linux.vnet.ibm.com>
> >
> > Adding in some debugfs entries to help with debugging and
> > testing code.
> 
> > +++ linux-block/drivers/block/rsxx/core.c       2013-05-02 17:18:22.944239791 -0500
> > @@ -52,6 +54,191 @@ MODULE_PARM_DESC(force_legacy, "Force th
> >  static DEFINE_IDA(rsxx_disk_ida);
> >  static DEFINE_SPINLOCK(rsxx_ida_lock);
> >
> > +/* --------------------Debugfs Setup ------------------- */
> > +
> > +static struct dentry *rsxx_debugfs_root;
> 
> I didn't get if you use only one debugfs_root per instance? How do you
> distinguish two or more cards then?
> 
> > +static void rsxx_debugfs_dev_new(struct rsxx_cardinfo *card)
> > +{
> > +       if (!rsxx_debugfs_root)
> > +               return;
> 
> It seems you always call this after debugfs_init(). So, remove this
> check (keep in mind you have to check debugfs_init() return code - see
> below).
> 
> > +static void rsxx_debugfs_dev_remove(struct rsxx_cardinfo *card)
> > +{
> > +}
> 
> Useless function. See below.
> 
> > +static void rsxx_debugfs_init(void)
> > +{
> > +       rsxx_debugfs_root = debugfs_create_dir(DRIVER_NAME, NULL);
> 
> Same comment for DRIVER_NAME as for global variable debugfs_root above.
> 
> > +       if (!rsxx_debugfs_root)
> > +               return;
> 
> It should be checked for NULL and for ERR_PTR. Return error instead of void.
> 
> > +static void rsxx_debugfs_destroy(void)
> > +{
> > +       if (!rsxx_debugfs_root)
> > +               return;
> 
> Use debugfs_remove_recursive().
> It's also NULL-proof.
> 
> > +       debugfs_remove(rsxx_debugfs_root);
> > +       rsxx_debugfs_root = NULL;
> 
> If you will use this on card based, you  probably have to move this
> from global space to card space.
> 
> > +++ linux-block/drivers/block/rsxx/rsxx_priv.h  2013-05-02 17:17:25.154498245 -0500
> > @@ -181,6 +181,11 @@ struct rsxx_cardinfo {
> >
> >         int                     n_targets;
> >         struct rsxx_dma_ctrl    *ctrl;
> > +
> > +       /* Debugfs Variables */
> > +       struct dentry           *debugfs_dir;
> > +       struct dentry           *debugfs_stats;
> > +       struct dentry           *debugfs_pci_regs;
> 
> No need to keep those pointers since you may use debugfs_remove_recursive().
> 
> --
> With Best Regards,
> Andy Shevchenko
> 

