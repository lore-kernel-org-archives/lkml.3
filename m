Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbaENKCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 06:02:53 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:41586 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbaENKCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 06:02:51 -0400
Date: Wed, 14 May 2014 13:02:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ 083/143] net: clamp ->msg_namelen instead of returning an error
Message-ID: <20140514100215.GD16836@mwanda>
References: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
 <20140512003204.089772397@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140512003204.089772397@1wt.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 02:33:23AM +0200, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Dan Carpenter <dan.carpenter@oracle.com>
> 
> [ Upstream commit db31c55a6fb245fdbb752a2ca4aefec89afabb06 ]
> 
> If kmsg->msg_namelen > sizeof(struct sockaddr_storage) then in the
> original code that would lead to memory corruption in the kernel if you
> had audit configured.  If you didn't have audit configured it was
> harmless.
> 
> There are some programs such as beta versions of Ruby which use too
> large of a buffer and returning an error code breaks them.  We should
> clamp the ->msg_namelen value instead.
> 
> Fixes: 1661bf364ae9 ("net: heap overflow in __audit_sockaddr()")

You should probably take dbb490b96584 ('net: socket: error on a negative
msg_namelen') as well.  LTP has a test that passes negative values to
this code and expects an error return so my clamp patch breaks LTP.

regards,
dan carpenter

