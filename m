Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab3HVFDh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 01:03:37 -0400
Received: from 75-148-32-185-Colorado.hfc.comcastbusiness.net ([75.148.32.185]:44960
	"EHLO mail.scrye.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab3HVFDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 01:03:36 -0400
X-Greylist: delayed 494 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Aug 2013 01:03:36 EDT
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: add sysfs_create/remove_groups()
From: Anthony Foiani <tkil@scrye.com>
Reply-To: Anthony Foiani <tkil@scrye.com>
X-Attribution: Tony
References: <20130821203506.GA1663@kroah.com> <5215254B.7000000@infradead.org>
	<20130821204750.GB4546@kroah.com>
Date: Wed, 21 Aug 2013 22:55:19 -0600
In-Reply-To: <20130821204750.GB4546@kroah.com> (Greg Kroah-Hartman's message of "Wed\, 21 Aug 2013 13\:47\:50 -0700")
Message-ID: <g38q2l3yg.fsf@dworkin.scrye.com>
User-Agent: Gnus/5.101 (Gnus v5.10.10) XEmacs/21.5-b33 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> + * sysfs_create_groups - given a directory kobject, create a bunch of attribute groups
> + * @kobj:	The kobject to create the group on
> + * @groups:	The attribute groups to create, NULL terminated
> + *
> + * This function creates a bunch of attribute groups.  If an error occurs when
> + * creating a group, all previously created groups will be removed, unwinding
> + * everything back to the original state when this function was called.
> + * It will explicitly warn and error if any of the attribute files being
> + * created already exist.
> + *
> + * Returns 0 on success or error code from sysfs_create_groups on error.

"... from sysfs_create_group on error"
                       ^^^^^ (note singular, not plural)

Otherwise it's a bit of a tautology...

Maybe rename to "sysfs_(create|remove)_multiple_groups" (or
..._many_groups) to avoid this kind of one-char difference?

> + * sysfs_remove_groups - remove a list of groups
> + *
> + * kobj:	The kobject for the groups to be removed from
> + * groups:	NULL terminated list of groups to be removed
> + *
> + * If groups is not NULL, the all groups will be removed from the kobject

"If groups is not NULL, remove listed groups from the kobject"

(I also played around with using pointer arithmetic instead of array
accesses for these two functions; it cut a few lines of code, but not
enough to bother, I don't think.)

Thanks,
Tony
