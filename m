Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103AbaGAPaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 11:30:08 -0400
Received: from plane.gmane.org ([80.91.229.3]:43737 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920AbaGAPaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 11:30:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Vadim Lebedev <vadim@mbdsys.com>
Subject: Questions about Optimizing network I/O
Date: Tue, 1 Jul 2014 15:19:35 +0000 (UTC)
Message-ID: <loom.20140701T161608-685@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 193.248.179.81 (Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.97 Safari/537.36)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm looking for advice on optimizing a SOCKS proxy software which i modified
to support TCP <=> UDP tunnelling.
The modification of standard SOCKS protocol is pretty straightforward, i've 
added a command that tells to socks server that destination socket is a UDP 
socket so the server expects the tcp packets  for this destination to be 
prefixed with 4 byte length. The server reads the length prefix the reads the 
'length' bytes for the tcp stream and send the data (without the length 
prefix) to the destination address as UDP datagram.
The return path (from UDP to TCP) is even simpler: The server read  UDP
datagram into a buffer whre 4 bytes are reserved for length prefix,  fill 
this prefix with the length of just read packet and send the buffer to the 
tcp socket.

When testing my SOCKS server i see that the TCP -> UDP processing generates a 
lot o CPU load while UDP -> TCP or normal SOCKS TCP <=> TCP processing 
generates relatively light cpu load.

So i'm looking for the way to optimize TCP -> UDP path.
My idea is to write a kernel module which will define an ioctl with 2 params
TCP_fd and UDP_fd and will do TCP to UDP processing completely in kernel mode
without copying data frmo/to skbufs....


Any ideas about this approach?

Thanks
Vadim

