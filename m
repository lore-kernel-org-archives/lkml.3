Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab3KSSkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 13:40:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39970 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab3KSSkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 13:40:32 -0500
Date: Tue, 19 Nov 2013 10:40:53 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peng Tao <bergwolf@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andreas Dilger <andreas.dilger@intel.com>,
        Lai Siyao <lai.siyao@intel.com>
Subject: Re: [PATCH 9/9] staging/lustre/ldlm: fix resource/fid check, use
 DLDLMRES
Message-ID: <20131119184053.GA19358@kroah.com>
References: <1384867428-8395-1-git-send-email-bergwolf@gmail.com>
 <1384867428-8395-10-git-send-email-bergwolf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384867428-8395-10-git-send-email-bergwolf@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 09:23:48PM +0800, Peng Tao wrote:
> From: Andreas Dilger <andreas.dilger@intel.com>
> 
> In ll_md_blocking_ast() the FID/resource comparison is incorrectly
> checking for fid_ver() stored in res_id.name[2] instead of name[1]
> changed since http://review.whamcloud.com/2271 (commit 4f91d5161d00)
> landed.  This does not impact current clients, since name[2] and
> fid_ver() are always zero, but it could cause problems in the future.
> 
> In ldlm_cli_enqueue_fini() use ldlm_res_eq() instead of comparing
> each of the resource fields separately.
> 
> Use DLDLMRES/PLDLMRES when printing resource names everywhere.

There are codingstyle warnings in this patch, please fix before
resending.

greg k-h
