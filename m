Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965581Ab3DPWAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 18:00:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56167 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965386Ab3DPWAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 18:00:43 -0400
Date: Tue, 16 Apr 2013 15:00:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>,
        LKML-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [Patch 1/1] cciss: bug fix, prevent cciss from loading in kdump
 kernel
Message-Id: <20130416150041.ef8bac2a578c8cb0e5df4c49@linux-foundation.org>
In-Reply-To: <20130415175906.GA16955@beardog.cce.hp.com>
References: <20130415175906.GA16955@beardog.cce.hp.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Apr 2013 12:59:06 -0500 Mike Miller <mike.miller@hp.com> wrote:

> Patch 1/1
> 
> If hpsa is selected as the Smart Array driver cciss may try to load in the
> kdump kernel. When this happens kdump fails and a core file cannot be created.
> This patch prevents cciss from trying to load in this scenario. This effects
> primarily older Smart Array controllers.
> 

OK, this is weird.  kdump and scsi drivers are pretty darn remote things
and I've never heard of such an interaction.  Can you tell us a bit more
about how and why this happened?  Is there something special about
cciss, or can we expect similar kdump interactions with other device drivers?


