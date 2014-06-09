Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433AbaFIVHx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 17:07:53 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:44848 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195AbaFIVHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 17:07:50 -0400
X-Greylist: delayed 504 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Jun 2014 17:07:49 EDT
Date: Mon, 9 Jun 2014 23:59:17 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Seth Bollinger <sethb@digi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org
Subject: Linux 3.15: SPARC serial console regression
Message-ID: <20140609205917.GA913@drone.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While testing the final 3.15, I noticed the serial console (sunsab)
does not work anymore on Sun Ultra.

It will tx fine the console output during the boot. But then I try
to type something e.g. at the login: prompt, it behaves oddly:
it re-transmits some old output, and then stalls for a few secs, usually
for each character. Typed characters are however received correctly.
But the console is impossible to use...

I bisected this to:

717f3bbab3c7628736ef738fdbf3d9a28578c26c is the first bad commit
commit 717f3bbab3c7628736ef738fdbf3d9a28578c26c
Author: Seth Bollinger <sethb@digi.com>
Date:   Tue Mar 25 12:55:37 2014 -0500

    serial_core: Fix conditional start_tx on ring buffer not empty

A.
