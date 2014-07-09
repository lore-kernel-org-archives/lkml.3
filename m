Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbaGIIk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 04:40:57 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54852 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181AbaGIIkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 04:40:55 -0400
Date: Wed, 9 Jul 2014 01:40:55 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, jbottomley@parallels.com, jasowang@redhat.com,
        apw@canonical.com, linux-scsi@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/8] Drivers: scsi: storvsc: Filter commands based on the
 storage protocol version
Message-ID: <20140709084055.GB6012@infradead.org>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-2-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404866812-26950-2-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 05:46:46PM -0700, K. Y. Srinivasan wrote:
> Going forward it is possible that some of the commands that are not currently
> implemented will be implemented on future Windows hosts. Make command filtering
> depend on the host version.

> +	if (vmstor_current_major <= VMSTOR_WIN8_MAJOR) {
> +		/*
> +		 * On legacy hosts filter unimplemented commands.
> +		 */
> +		if (!storvsc_scsi_cmd_ok(scmnd)) {
> +			scmnd->scsi_done(scmnd);
> +			return 0;
> +		}

So post-Win8 versions don't need command filering as they can properly
reject commands they don't understand?  If that's the case please state
it in the patch description.

