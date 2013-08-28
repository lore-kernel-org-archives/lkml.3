Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab3H1S6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 14:58:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50513 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab3H1S6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 14:58:04 -0400
Date: Wed, 28 Aug 2013 12:00:24 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        "Serge E. Hallyn" <serge@hallyn.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: Re: [REVIEW][PATCH 2/2] sysfs: Restrict mounting sysfs
Message-ID: <20130828190024.GA3691@kroah.com>
References: <878uzmhkqg.fsf@xmission.com>
 <874naahkng.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874naahkng.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 02:46:27PM -0700, Eric W. Biederman wrote:
> 
> Don't allow mounting sysfs unless the caller has CAP_SYS_ADMIN rights
> over the net namespace.  The principle here is if you create or have
> capabilities over it you can mount it, otherwise you get to live with
> what other people have mounted.
> 
> Instead of testing this with a straight forward ns_capable call,
> perform this check the long and torturous way with kobject helpers,
> this keeps direct knowledge of namespaces out of sysfs, and preserves
> the existing sysfs abstractions.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

Odd, but makes sense.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
