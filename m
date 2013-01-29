Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab3A2TtK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 14:49:10 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:49632 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab3A2TtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 14:49:04 -0500
Date: Tue, 29 Jan 2013 11:49:01 -0800
From: Tejun Heo <tj@kernel.org>
To: aris@redhat.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH v3 5/9] devcg: prepare may_access() for hierarchy support
Message-ID: <20130129194901.GF6824@mtj.dyndns.org>
References: <20130129190759.117458287@napanee.usersys.redhat.com>
 <20130129190759.993951510@napanee.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130129190759.993951510@napanee.usersys.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2013 at 02:08:04PM -0500, aris@redhat.com wrote:
> Currently may_access() is only able to verify if an exception is valid for the
> current cgroup, which has the same behavior. With hierarchy, it'll be also used
> to verify if a cgroup local exception is valid towards its cgroup parent, which
> might have different behavior.
> 
> v2:
> - updated patch description
> - rebased on top of a new patch to expand the may_access() logic to make it
>   more clear
> - fixed argument description order in may_access()
> 
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Serge Hallyn <serge.hallyn@canonical.com>
> Signed-off-by: Aristeu Rozanski <aris@redhat.com>
> 
> ---
>  security/device_cgroup.c |   44 +++++++++++++++++++++++++++-----------------
>  1 file changed, 27 insertions(+), 17 deletions(-)
> 
> --- github.orig/security/device_cgroup.c	2013-01-29 11:49:15.514669057 -0500
> +++ github/security/device_cgroup.c	2013-01-29 11:49:15.795673240 -0500
> @@ -354,9 +354,11 @@ 	return 0;
>   *		verify if a certain access is allowed.
>   * @dev_cgroup: dev cgroup to be tested against
>   * @refex: new exception
> + * @behavior: behavior of the exception
>   */
> -static int may_access(struct dev_cgroup *dev_cgroup,
> -		      struct dev_exception_item *refex)
> +static bool may_access(struct dev_cgroup *dev_cgroup,
> +		       struct dev_exception_item *refex,
> +		       enum devcg_behavior behavior)

Probably belongs to the previous patch.  Other than that,

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
