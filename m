Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbaJXDwa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 23:52:30 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50567 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533AbaJXDw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 23:52:28 -0400
Message-ID: <1414122516.2120.6.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 1/2] ima: check xattr value length in
 ima_inode_setxattr()
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>,
        linux-security-module@vger.kernel.org,
        linux-ima-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        jack@suse.cz, dmitry.kasatkin@gmail.com
Date: Thu, 23 Oct 2014 23:48:36 -0400
In-Reply-To: <alpine.LRH.2.11.1410241355020.30398@namei.org>
References: <cover.1414071910.git.d.kasatkin@samsung.com>
	 <5b1f234e8515c10c96a16868ff4341f29460f38f.1414071910.git.d.kasatkin@samsung.com>
	 <alpine.LRH.2.11.1410241355020.30398@namei.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102403-0029-0000-0000-000000DEB079
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-24 at 13:55 +1100, James Morris wrote: 
> On Thu, 23 Oct 2014, Dmitry Kasatkin wrote:
> 
> > ima_inode_setxattr() can be called with no value. Function does not
> > check the length so that following command can be used to produce
> > kernel oops: setfattr -n security.ima FOO. This patch fixes it.
> 
> I'd like to see more review/acks on this before sending it to Linus.
> 
> Mimi?

This fixes the oops, but a more complete solution would at least test
the first byte, verifying that it is valid.  As previously described
http://sourceforge.net/p/linux-ima/mailman/message/32958242/ I think we
can do better than this.

Mimi

> 
> 
> -- 
> James Morris
> <jmorris@namei.org>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


