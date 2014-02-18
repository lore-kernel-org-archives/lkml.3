Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550AbaBRX1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:27:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753671AbaBRX1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 18:27:12 -0500
Date: Tue, 18 Feb 2014 18:27:02 -0500
From: Dave Jones <davej@redhat.com>
To: David Rientjes <rientjes@google.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] Set bounds on what /proc/self/make-it-fail accepts.
Message-ID: <20140218232702.GA26051@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	David Rientjes <rientjes@google.com>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
References: <20140218220606.GA9712@redhat.com>
 <alpine.DEB.2.02.1402181429060.20772@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402181429060.20772@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 02:32:02PM -0800, David Rientjes wrote:
 > On Tue, 18 Feb 2014, Dave Jones wrote:
 > 
 > > /proc/self/make-it-fail is a boolean, but accepts any number, including
 > > negative ones. Change variable to unsigned, and cap upper bound at 1.
 > 
 > Hmm, this would break anything that uses anything other than one to enable 
 > it, but it looks like Documentation/fault-injection/fault-injection.txt 
 > only provides an example for when it does equal one, so it's probably an 
 > ok change.  I'm just wondering why non-zero is wrong?  Is this an 
 > interface that will be extended to support other modes?

"Wrong" is perhaps too strong a word, but we only ever check it for non-zero state,
so it seems at best suboptimal to allow strange configurations.

When I saw I could set it to nonsense values like -1, I figured it could
use some idiot proofing. The lack of any checking at all surprised me.

Future extension of this interface seems unlikely given the boolean sounding name.
(Though we've done that in the past with things like the overcommit_memory sysctl,
 with pretty awful end-user results).

	Dave

