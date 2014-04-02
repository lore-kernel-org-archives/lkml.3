Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667AbaDBQrO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 12:47:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46276 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932648AbaDBQrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 12:47:10 -0400
Date: Wed, 2 Apr 2014 18:47:09 +0200
From: David Sterba <dsterba@suse.cz>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Chris Mason <clm@fb.com>, jbacik@fb.com,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Btrfs lockdep with 3.15 merge window v3.14-751-g683b6c6f82a6
Message-ID: <20140402164709.GI29256@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josh Boyer <jwboyer@fedoraproject.org>,
	Chris Mason <clm@fb.com>, jbacik@fb.com,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	"Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
References: <CA+5PVA787+k0TVFUuo6PxNWMwffWDKixmt2C+E4_9szUJatYkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA787+k0TVFUuo6PxNWMwffWDKixmt2C+E4_9szUJatYkw@mail.gmail.com>
User-Agent: Mutt/1.5.22.1-rc1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 06:23:11PM -0400, Josh Boyer wrote:
> Below is a lockdep spew I have on a local VM running Linus' tree as of
> this afternoon.  The specific git commit is v3.14-751-g683b6c6f82a6.

> [  295.349016]        CPU0                    CPU1
> [  295.349016]        ----                    ----
> [  295.349016]   lock(&found->groups_sem);
> [  295.349016]                                local_irq_disable();
> [  295.349016]                                lock(&delayed_node->mutex);
> [  295.349016]                                lock(&found->groups_sem);
> [  295.349016]   <Interrupt>
> [  295.349016]     lock(&delayed_node->mutex);

Fixed by https://patchwork.kernel.org/patch/3894781/
