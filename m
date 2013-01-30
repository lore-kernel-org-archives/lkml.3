Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab3A3JzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 04:55:04 -0500
Received: from smtp4.nedap.com ([213.160.213.85]:56557 "EHLO smtp.nedap.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754324Ab3A3JzB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 04:55:01 -0500
From: Dirkjan Bussink <dirkjan.bussink@nedap.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 30 Jan 2013 10:55:00 +0100
Subject: Re: [PATCH] tty: Prevent deadlock in n_gsm driver
Thread-Topic: [PATCH] tty: Prevent deadlock in n_gsm driver
Thread-Index: Ac3+z92oq7W1hUreSOS0NBwsoB2MCg==
Message-ID: <E78C7BE9-BB39-409D-B2F9-4DAB81BE9513@nedap.com>
References: <4B03AD17-906A-4FBF-9F00-3F860395B229@nedap.com>
 <20130130051213.GA26675@kroah.com>
In-Reply-To: <20130130051213.GA26675@kroah.com>
Accept-Language: en-US, nl-NL
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, nl-NL
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 30 Jan 2013, at 06:12, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> It doesn't apply cleanly to the linux-next tree, can you refresh this
> and resend it so that I can apply it?  If you want it backported to the
> stable kernel releases, we can only do that after it gets into Linus's
> tree, see the file, Documentation/stable_kernel_rules.txt for details
> about this.

I've reapplied the patch to linux-next and submitted it just now. Is there
anything additionally that needs to be done to merge this back to stable
after this patch is applied? 

I also changed the additional check conditions by changing them into

if (dlci->state == DLCI_CLOSED)

During testing I've found that there can be a case where gsmtty_ioctl was called
while it was still in the state DLCI_OPENING and this is not a problematic case.
Therefore I changed the check from the original patch to the one shown in the
new one.

-- 
Regards,

Dirkjan Bussink

