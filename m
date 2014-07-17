Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933299AbaGQNu7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:50:59 -0400
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:43147 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932400AbaGQNu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:50:58 -0400
Date: Thu, 17 Jul 2014 08:50:54 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Pranith Kumar <bobby.prani@gmail.com>
cc: Randy Dunlap <rdunlap@infradead.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] doc: Add remote CPU access details and others to
 this_cpu_ops.txt
In-Reply-To: <1405552141-8506-1-git-send-email-bobby.prani@gmail.com>
Message-ID: <alpine.DEB.2.11.1407170848490.27584@gentwo.org>
References: <1405552141-8506-1-git-send-email-bobby.prani@gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jul 2014, Pranith Kumar wrote:

> +You can also do the following to convert the datap offset to an address
> +
> +	struct data *p = this_cpu_ptr(&datap);
> +
> +but, passing of pointers calculated via this_cpu_ptr to other cpus is
> +unusual and should be avoided.
> +
> +Such remote accesses to per CPU data are not guaranteed to be atomic
> +anymore. You will have to use atomic_t and rely on the standard atomic
> +operations for these remote accesses to be atomic.

The use of atomic_t implies a remote write operation to a percpu area.

atomic_t needs to be avoided. If data needs to be modified from multiple
cpus then it usually does not belong into a percpu area.
