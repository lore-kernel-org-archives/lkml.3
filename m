Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaKXJSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 04:18:45 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:58539 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaKXJSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 04:18:40 -0500
Date: Mon, 24 Nov 2014 01:18:35 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Barto <mister.freeman@laposte.net>
Cc: Christoph Hellwig <hch@infradead.org>,
        "Elliott, Robert (Server Storage)" <Elliott@hp.com>,
        Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: BUG in scsi_lib.c due to a bad commit
Message-ID: <20141124091835.GA21579@infradead.org>
References: <20141120060933.GA21432@infradead.org>
 <546E2880.5070303@laposte.net>
 <20141120175316.GA19590@infradead.org>
 <546E32A5.4040202@laposte.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546E32A5.4040202@laposte.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 07:27:49PM +0100, Barto wrote:
> but the sata DVD burner is now connected on a Jmicron sata PCIe card (
> with this configuration the bug doesn't occur ), I don't know if this
> change can modify the result of your command,
> 
> here is the result of another command :
> 
> $ for i in /sys/class/scsi_host/*; do cat $i/proc_name; done
> pata_jmicron
> pata_jmicron
> ata_piix
> ata_piix
> ata_piix
> ata_piix
> ahci
> ahci

Interesting.  So the jmicron card also has a queue depth of just one,
but the error still occurs?  I've added the linux-ide list, maybe
someone there has an idea how piix vs jmicron could have such different
behaviors for queueing or error handling.

