Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353AbaAMXHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 18:07:51 -0500
Received: from mo4-p04-ob.smtp.rzone.de ([81.169.146.179]:19419 "EHLO
	mo4-p04-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbaAMXHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 18:07:48 -0500
X-RZG-CLASS-ID: mo04
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWJ4Kkzc/qnW2/7rNLk=
Date: Tue, 14 Jan 2014 00:07:40 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: konrad.wilk@oracle.com, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org, david.vrabel@citrix.com
Subject: Re: [PATCH] xen-blkfront: remove type check from
 blkfront_setup_discard
Message-ID: <20140113230740.GA23544@aepfle.de>
References: <1389371301-29532-1-git-send-email-olaf@aepfle.de>
 <52D036FC.6000308@oracle.com>
 <20140110213746.GA933@aepfle.de>
 <52D073F0.5020400@oracle.com>
 <20140113093032.GA13919@aepfle.de>
 <52D3FD67.2060708@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52D3FD67.2060708@oracle.com>
User-Agent: Mutt/1.5.22.rev6346 (2013-10-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, Boris Ostrovsky wrote:

> On 01/13/2014 04:30 AM, Olaf Hering wrote:
> >>Similarly, if xenbug_gather("discard-secure") fails, I think the code will
> >>assume that secure discard has not been requested. I don't know what
> >>security implications this will have but it sounds bad to me.
> >There are no security implications, if the backend does not advertise it
> >then its not present.
> 
> Right. But my questions was what if the backend does advertise it and wants
> the frontent to use it but xenbus_gather() in the frontend fails. Do we want
> to silently continue without discard-secure? Is this safe?

The frontend can not know that the backend advertised discard-secure
because the frontend just failed to read the property which indicates
discard-secure should be enabled.

Olaf
