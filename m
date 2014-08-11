Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbaHKNCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 09:02:45 -0400
Received: from mout.web.de ([212.227.15.14]:56526 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204AbaHKNCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 09:02:43 -0400
Message-ID: <53E8BE84.3080505@users.sourceforge.net>
Date: Mon, 11 Aug 2014 15:00:52 +0200
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: Coccinelle <cocci@systeme.lip6.fr>, kernel-janitors@vger.kernel.org,
        Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/coccinelle/free/ifnullfree.cocci: simplify and
 extend to of_node_put
References: <1407752653-16883-1-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1407752653-16883-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:OVtafOIBnMlRPcLEZjbyspecuKIeXkz93bebFd0UT5do45LvWwo
 8mAJ6dozurb4J50EhX2icumnQxMIqtFGkmR3/DuXfXcRFLb41QCufsUbZdKU8ZeH/UUaNK8
 P0grVC28UXqVduLyvHma05mIH4aOqPfIvKmWtqdGkLtCwwsutdBCGl/6OlNpMViQG/n/eSh
 Dtrb+8/PQ0gjT246ZrMCA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  @r depends on context || report || org @
> @@ -37,7 +35,8 @@ position p;
>  @@
>  
>  * if (E)
> -*	\(kfree@p\|debugfs_remove@p\|debugfs_remove_recursive@p\|usb_free_urb\)(E);
> +*  \(kfree@p\|debugfs_remove@p\|debugfs_remove_recursive@p\|usb_free_urb@p\|
> +*    of_node_put@p\)(E);

Why do you want to limit this semantic patch pattern to such a small list of
function names?

Would you like to consider also the hundreds of other functions which perform
input parameter validation?
Are you interested to make the checked list more complete with further
(eventually automatic?) extensions?

Regards,
Markus
