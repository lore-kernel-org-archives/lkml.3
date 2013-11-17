Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003Ab3KQNnT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 08:43:19 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:57410 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab3KQNnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 08:43:09 -0500
Message-ID: <1384695783.5181.49.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 9/9] KEYS: Fix encrypted key type update method
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: d.kasatkin@samsung.com, zohar@us.ibm.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 17 Nov 2013 08:43:03 -0500
In-Reply-To: <3709.1384679869@warthog.procyon.org.uk>
References: <1384660289.5181.8.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <1384368349.2550.17.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <20131104162216.10177.98067.stgit@warthog.procyon.org.uk>
	 <20131104162321.10177.34033.stgit@warthog.procyon.org.uk>
	 <29885.1384451991@warthog.procyon.org.uk>
	 <3709.1384679869@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111713-0928-0000-0000-000003C4D4A9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-11-17 at 09:17 +0000, David Howells wrote:
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > +    keyctl control <keyid> encrypted change-master-key \
> > +		"update key-type:master-key-name"
> 
> Why include the word "update" in the argument?  Isn't that implicit in the
> command name?

Agreed, it's redundant. encrypted_control() currently strips off the
"encrypted change-master-key" string and then calls datablob_parse(),
which still expects a key_cmd (eg. new, load, or update).  Instead, we
could pass "change-master-key" to datablob_parse() as the key_cmd and
make the necessary changes.

thanks,

Mimi

