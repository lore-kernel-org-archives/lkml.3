Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbaK1KBP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 05:01:15 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:38929 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaK1KBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 05:01:14 -0500
Date: Fri, 28 Nov 2014 13:00:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: =?iso-8859-1?Q?Lo=EFc?= Pefferkorn <loic@loicp.eu>
Cc: Greg KH <gregkh@linuxfoundation.org>, keith.mannthey@intel.com,
        devel@driverdev.osuosl.org, andreas.dilger@intel.com,
        linux-kernel@vger.kernel.org, oleg.drokin@intel.com, gdonald@gmail.com,
        HPDD-discuss@ml01.01.org, john.hammond@intel.com
Subject: Re: [PATCH] staging: lustre: fix sparse warnings related to lock
 context imbalance
Message-ID: <20141128100045.GC4860@mwanda>
References: <02a457cec587341d0f1665491f6360323694b008.1417017302.git.loic@loicp.eu>
 <20141126205443.GB10615@kroah.com>
 <20141127183410.GA4582@iron>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141127183410.GA4582@iron>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 07:34:10PM +0100, Loïc Pefferkorn wrote:
> 1827         if (valid != 0) {
> 1828             cl_object_attr_lock(obj);
> 1829             cl_object_attr_set(env, obj, attr, valid);
> 1830             cl_object_attr_unlock(obj);
> 
> after:
> 
> 1827         if (valid != 0) {
> 1828             spin_lock(cl_object_attr_guard(obj));
> 1829             cl_object_attr_set(env, obj, attr, valid);
> 1830             spin_unlock(cl_object_attr_guard(obj));

The word "_object" doesn't add any new information to the name.  If you
remove it then the code is improved.

		spin_lock(cl_attr_guard(obj));
		cl_attr_set(env, obj, attr, valid);
		spin_unlock(cl_attr_guard(obj));


regards,
dan carpenter

