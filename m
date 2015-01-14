Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbbANUOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 15:14:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbbANUON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 15:14:13 -0500
From: Paul Moore <pmoore@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Rob Landley <rob@landley.net>, Josh Boyer <jwboyer@fedoraproject.org>,
        initramfs <initramfs@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module <linux-security-module@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Fionnuala Gunter <fin@linux.vnet.ibm.com>,
        "casey.schaufler" <casey.schaufler@intel.com>, selinux@tycho.nsa.gov
Subject: Re: [RFC][PATCH 6/9] gen_initramfs_list.sh: include xattrs
Date: Wed, 14 Jan 2015 14:36:46 -0500
Message-ID: <1584934.WkKQGAFadF@sifl>
Organization: Red Hat
User-Agent: KMail/4.14.3 (Linux/3.16.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <1421205803.2119.110.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <1420663980-20842-1-git-send-email-zohar@linux.vnet.ibm.com> <54B5913C.5050109@landley.net> <1421205803.2119.110.camel@dhcp-9-2-203-236.watson.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 13, 2015 10:23:23 PM Mimi Zohar wrote:
> I would assume only 'security.evm' is not portable as it attempts to
> tightly bind the file metadata to the file data.  Casey?  Paul?

[NOTE: Added the SELinux mailing list to the CC line.]

The SELinux xattr should be portable assuming the security label's semantics 
remain constant across the different security policies.  If the label is 
completely unknown SELinux should handle it correctly, it will be treated as 
unlabeled until a module is loaded which defines the label.

Although, this is just for initramfs, yes?  If so, I'm not sure this matters 
that much from a practical point of view; Stephen or someone else from the 
SELinux list may have some thoughts on this.

-- 
paul moore
security @ redhat

