Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559AbaAJVhx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 16:37:53 -0500
Received: from mo4-p04-ob.smtp.rzone.de ([81.169.146.223]:51455 "EHLO
	mo4-p04-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaAJVhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 16:37:51 -0500
X-RZG-CLASS-ID: mo04
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWJ4Kkzc/qnW2/7iWQ==
Date: Fri, 10 Jan 2014 22:37:46 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: konrad.wilk@oracle.com, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org, david.vrabel@citrix.com
Subject: Re: [PATCH] xen-blkfront: remove type check from
 blkfront_setup_discard
Message-ID: <20140110213746.GA933@aepfle.de>
References: <1389371301-29532-1-git-send-email-olaf@aepfle.de>
 <52D036FC.6000308@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52D036FC.6000308@oracle.com>
User-Agent: Mutt/1.5.22.rev6346 (2013-10-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, Boris Ostrovsky wrote:

> If the call below fails, is it safe to continue using discard feature? At
> the least, are discard_granularity and discard_alignment guaranteed to have
> sane/safe values?

Its up to the toolstack to provide sane values. In the worst case
discard fails. In this specific case the three values are optional, so
the calls can fail. I do not know what happens if the backend device
actually needs the values, but the frontend can not send proper discard
requests. Hopefully it will not damage the hardware..

Olaf
