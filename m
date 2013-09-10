Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647Ab3IJXNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 19:13:11 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:40367 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab3IJXNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 19:13:07 -0400
Message-ID: <522F5275.7050001@hp.com>
Date: Tue, 10 Sep 2013 17:10:13 +0000
From: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>
CC: T Makphaibulchoke <tmac@hp.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "linux-ext4@vger.kernel.org List" <linux-ext4@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org Devel" <linux-fsdevel@vger.kernel.org>,
        aswin@hp.com, Linus Torvalds <torvalds@linux-foundation.org>,
        aswin_proj@lists.hp.com
Subject: Re: [PATCH v3 0/2] ext4: increase mbcache scalability
References: <1374108934-50550-1-git-send-email-tmac@hp.com> <1378312756-68597-1-git-send-email-tmac@hp.com> <20130905023522.GA21268@thunk.org> <52285395.1070508@hp.com> <0787C579-7E2C-4864-B8F4-98816E1E50A2@dilger.ca> <5229C939.8030108@hp.com> <62D71A85-C7EE-4F5F-B481-5329F0282044@dilger.ca> <20130910210250.GH29237@thunk.org>
In-Reply-To: <20130910210250.GH29237@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 09:02 PM, Theodore Ts'o wrote:
> On Tue, Sep 10, 2013 at 02:47:33PM -0600, Andreas Dilger wrote:
>> I agree that SELinux is enabled on enterprise distributions by default,
>> but I'm also interested to know how much overhead this imposes.  I would
>> expect that writing large external xattrs for each file would have quite
>> a significant performance overhead that should not be ignored.  Reducing
>> the mbcache overhead is good, but eliminating it entirely is better.
> 
> I was under the impression that using a 256 byte inode (which gives a
> bit over 100 bytes worth of xattr space) was plenty for SELinux.  If
> it turns out that SELinux's use of xattrs have gotten especially
> piggy, then we may need to revisit the recommended inode size for
> those systems who insist on using SELinux...  even if we eliminate the
> overhead associated with mbcache, the fact that files are requiring a
> separate xattr is going to seriously degrade performance.
> 
> 	       	  	   	     - Ted
> 

Thank you Andreas and Ted for the explanations and comments.  Yes, I see both of your points now.  Though we may reduce the mbcache overhead, due to the overhead of additional xattr I/O it would be better to provide some data to help users or distros to determine whether they will be better off completely disabling SELinux or increasing the inode size.  I will go ahead and run the suggested experiments and get back with the results.

Thanks,
Mak.

