Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab3CEIK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 03:10:28 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:43150 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab3CEIK1 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Tue, 5 Mar 2013 03:10:27 -0500
Message-Id: <5135B6B702000078000C2FFF@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Tue, 05 Mar 2013 08:11:19 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <roger.pau@citrix.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH RFC 12/12] xen-block: implement
 indirect descriptors
References: <1362047335-26402-1-git-send-email-roger.pau@citrix.com>
 <1362047335-26402-13-git-send-email-roger.pau@citrix.com>
 <512F4B4402000078000C1E5B@nat28.tlf.novell.com>
 <512F46F5.5040105@citrix.com>
 <512F69A002000078000C2020@nat28.tlf.novell.com>
 <20130304204427.GM15386@phenom.dumpdata.com>
In-Reply-To: <20130304204427.GM15386@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 04.03.13 at 21:44, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> <nods> 'op' sounds good. With a comment saying it can do all of the 
> BLKIF_OPS_..
> except the BLKIF_OP_INDIRECT one. Thought one could in theory chain
> it that way for fun.

In fact I'd like to exclude chaining as well as BLKIF_OP_DISCARD here.
The former should - if useful for anything - be controlled by a
separate feature flag, and the latter is plain pointless to indirect.
And I reckon the same would apply to BLKIF_OP_FLUSH_DISKCACHE
and BLKIF_OP_RESERVED_1 - i.e. it might be better to state that
indirection is only permitted for normal I/O (read/write) ops.

Jan

