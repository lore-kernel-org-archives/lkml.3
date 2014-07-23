Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048AbaGWOmy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 10:42:54 -0400
Received: from zill.ext.symas.net ([69.43.206.106]:38788 "EHLO
	zill.ext.symas.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904AbaGWOmv (ORCPT
	<rfc822;Linux-Kernel@Vger.Kernel.ORG>);
	Wed, 23 Jul 2014 10:42:51 -0400
X-Greylist: delayed 1935 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jul 2014 10:42:51 EDT
Message-ID: <53CFC258.6050803@symas.com>
Date: Wed, 23 Jul 2014 07:10:32 -0700
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:29.0) Gecko/20100101 Firefox/29.0 SeaMonkey/2.26a1
MIME-Version: 1.0
To: Matthew Wilcox <willy@linux.intel.com>,
        Linux Kernel Mailing List <Linux-Kernel@vger.kernel.org>
Subject: Re: [PATCH v8 00/22] Support ext4 on NV-DIMMs
References: <cover.1406058387.git.matthew.r.wilcox@intel.com> <00ad731b459e32ce965af8530bcd611a141e41b6.1406058387.git.matthew.r.wilcox@intel.com> <20140723121025.GE10317@node.dhcp.inet.fi> <20140723135514.GB6754@linux.intel.com>
In-Reply-To: <20140723135514.GB6754@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> One of the primary uses for NV-DIMMs is to expose them as a block device
> and use a filesystem to store files on the NV-DIMM. While that works,
> it currently wastes memory and CPU time buffering the files in the page
> cache. We have support in ext2 for bypassing the page cache, but it
> has some races which are unfixable in the current design. This series
> of patches rewrite the underlying support, and add support for direct
> access to ext4.

This is an awful lot of work to go thru just to get a glorified ext4 RAMdisk. 
RAMdisks are one of the worst possible uses for RAM, requiring users to 
explicitly copy files to them before getting any benefit. Using RAM for a page 
cache instead brings benefits to all file accesses without requiring any user 
intervention.

If the NVDIMM range was reserved for exclusive use of the page cache, then you 
would have an avenue to get persistence/safety for every filesystem mounted on 
a machine, not just a special case ext4.

-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
