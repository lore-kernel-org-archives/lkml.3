Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbaIVSD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 14:03:57 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:37152 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbaIVSDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 14:03:55 -0400
Date: Mon, 22 Sep 2014 12:03:45 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Ashley Lai <ashley@ashleylai.com>
Cc: Anton Blanchard <anton@samba.org>, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [tpmdd-devel] [PATCH 1/2] tpm/tpm_ibmvtpm: Fail in
 ibmvtpm_get_data if driver_data is bad
Message-ID: <20140922180345.GD28082@obsidianresearch.com>
References: <20140920072942.27c28768@kryten>
 <alpine.DEB.2.10.1409221219150.4510@ant>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1409221219150.4510@ant>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 12:43:27PM -0500, Ashley Lai wrote:
> Hi Anton,
> 
> Thanks for the patch.  Is this oops easy to recreate?  If so could 
> you give us the steps to reproduce?

This looks like it is probably related to the uninitialization mess in
the TPM core (resource held during module unload?). A driver should
not have to defend itself against null drvdata, so the BUG makes
more sense than the if it is replacing.

Jason
