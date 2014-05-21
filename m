Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642AbaEUCWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 22:22:09 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33233 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750735AbaEUCWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 22:22:07 -0400
Message-ID: <1400638922.2481.18.camel@dabdike>
Subject: Re: [PATCH RESEND] scsi: Output error messages using structured
 printk in single line
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hannes Reinecke <hare@suse.de>, Prarit Bhargava <prarit@redhat.com>,
        linux-scsi@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Wed, 21 May 2014 11:22:02 +0900
In-Reply-To: <20140227041738.31316.14684.stgit@yunodevel>
References: <20140227041738.31316.14684.stgit@yunodevel>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.12.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-27 at 13:17 +0900, Yoshihiro YUNOMAE wrote:
> +/* Maximum size of a local buffer for structured printk */
> +#define SCSI_LOG_LINE_MAX 512
> +
> +/* Local buffer for structured printk */
> +struct scsi_log_line {
> +	int offset;
> +	char buf[SCSI_LOG_LINE_MAX];
> +};

This piece isn't going to fly; it's an on stack allocation of 0.5kb;
that's too much for small stack kernels.  Just changing this to a kalloc
is going be problematic too because we're in the io paths and the
allocation may fail.  So I appreciate the problem, but I don't think the
solution works.  Could we just tag the messages and use grep to put them
back together?

James


