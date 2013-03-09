Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734Ab3CIUtz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 15:49:55 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51992 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab3CIUtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 15:49:53 -0500
Date: Sat, 9 Mar 2013 15:49:40 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Don Dutile <ddutile@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Asit Mallick <asit.k.mallick@intel.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2] irq: add quirk for broken interrupt remapping on 55XX
 chipsets
Message-ID: <20130309204940.GA31808@neilslaptop.think-freely.org>
References: <1362158276-4901-1-git-send-email-nhorman@tuxdriver.com>
 <1362423859-18516-1-git-send-email-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362423859-18516-1-git-send-email-nhorman@tuxdriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 02:04:19PM -0500, Neil Horman wrote:
> A few years back intel published a spec update:
> http://www.intel.com/content/dam/doc/specification-update/5520-and-5500-chipset-ioh-specification-update.pdf
> 
> For the 5520 and 5500 chipsets which contained an errata (specificially errata
> 53), which noted that these chipsets can't properly do interrupt remapping, and
> as a result the recommend that interrupt remapping be disabled in bios.  While
> many vendors have a bios update to do exactly that, not all do, and of course
> not all users update their bios to a level that corrects the problem.  As a
> result, occasionally interrupts can arrive at a cpu even after affinity for that
> interrupt has be moved, leading to lost or spurrious interrupts (usually
> characterized by the message:
> kernel: do_IRQ: 7.71 No irq handler for vector (irq -1)
> 
> There have been several incidents recently of people seeing this error, and
> investigation has shown that they have system for which their BIOS level is such
> that this feature was not properly turned off.  As such, it would be good to
> give them a reminder that their systems are vulnurable to this problem.
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> CC: Prarit Bhargava <prarit@redhat.com>
> CC: Don Zickus <dzickus@redhat.com>
> CC: Don Dutile <ddutile@redhat.com>
> CC: Bjorn Helgaas <bhelgaas@google.com>
> CC: Asit Mallick <asit.k.mallick@intel.com>
> CC: linux-pci@vger.kernel.org
> 
Ping, anyone want to Ack/Nack this?
Neil

