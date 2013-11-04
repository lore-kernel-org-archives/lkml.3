Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab3KDOXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 09:23:05 -0500
Received: from smtprelay0234.hostedemail.com ([216.40.44.234]:45420 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753407Ab3KDOXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 09:23:03 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::::::::::apw@cano
X-HE-Tag: sea94_8de2fc3c4cb04
X-Filterd-Recvd-Size: 2213
Message-ID: <1383525449.3042.27.camel@joe-AO722>
Subject: Re: [PATCH net-next 13/13] scripts/checkpatch.pl: Add
 dev_kfree_skb*(NULL) check to checkpatch
From: Joe Perches <joe@perches.com>
To: Govindarajulu Varadarajan <govindarajulu90@gmail.com>
Cc: davem@davemloft.net, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, IvDoorn@gmail.com, sbhatewara@vmware.com,
        samuel@sortiz.org, chas@cmf.nrl.navy.mil, roland@kernel.org,
        isdn@linux-pingi.de, jcliburn@gmail.com, benve@cisco.com,
        ssujith@cisco.com, jeffrey.t.kirsher@intel.com,
        jesse.brandeburg@intel.com, shahed.shaikh@qlogic.com,
        apw@canonical.com
In-Reply-To: <1383400074-30555-14-git-send-email-govindarajulu90@gmail.com>
References: <1383400074-30555-1-git-send-email-govindarajulu90@gmail.com>
	 <1383400074-30555-14-git-send-email-govindarajulu90@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Sun, 03 Nov 2013 16:37:29 -0800
Mime-Version: 1.0
X-Mailer: Evolution 3.8.4-0ubuntu1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-11-02 at 19:17 +0530, Govindarajulu Varadarajan wrote:
> Signed-off-by: Govindarajulu Varadarajan <govindarajulu90@gmail.com>
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -3719,7 +3719,7 @@ sub process {
>  # check for needless "if (<foo>) fn(<foo>)" uses
>  		if ($prevline =~ /\bif\s*\(\s*($Lval)\s*\)/) {
>  			my $expr = '\s*\(\s*' . quotemeta($1) . '\s*\)\s*;';
> -			if ($line =~ /\b(kfree|usb_free_urb|debugfs_remove(?:_recursive)?)$expr/) {
> +			if ($line =~ /\b(kfree|dev_kfree_skb|dev_kfree_skb_any|dev_kfree_skb_irq|usb_free_urb|debugfs_remove(?:_recursive)?)$expr/) {
>  				WARN('NEEDLESS_IF',
>  				     "$1(NULL) is safe this check is probably not required\n" . $hereprev);
>  			}

OK, but I think this is easier to read as

	dev_kfree_skb(?:_skb|_any|_irq)?


