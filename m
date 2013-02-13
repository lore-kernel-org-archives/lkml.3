Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759074Ab3BMS5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:57:06 -0500
Received: from BERING.ISR.CS.CMU.EDU ([128.2.209.223]:33631 "EHLO
	bering.isr.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756961Ab3BMS5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:57:04 -0500
X-Greylist: delayed 2527 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Feb 2013 13:57:04 EST
Date: Wed, 13 Feb 2013 13:14:51 -0500
From: Jan Harkes <jaharkes@cs.cmu.edu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-fsdevel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH review 18/85] coda: Restrict coda messages to the initial
 user namespace
Message-ID: <20130213181450.GJ30800@cs.cmu.edu>
Mail-Followup-To: "Eric W. Biederman" <ebiederm@xmission.com>,
	linux-fsdevel@vger.kernel.org,
	Linux Containers <containers@lists.linux-foundation.org>,
	linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serge@hallyn.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
 <1360777934-5663-18-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360777934-5663-18-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 09:51:07AM -0800, Eric W. Biederman wrote:
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Remove the slight chance that uids and gids in coda messages will be
> interpreted in the wrong user namespace.

Awesome, I was wondering how to handle uid's from different namespaces
cleanly in Coda's userspace daemon without resorting to exporting kuids
to userspace.

But this is a much more elegant solution, every namespace that cares
about Coda should just run their own mountpoint and userspace daemon.

Jan
