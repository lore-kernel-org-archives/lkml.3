Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933687AbaGPMsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 08:48:37 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:56608 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757574AbaGPMsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 08:48:32 -0400
Message-ID: <1405514905.1466.34.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: IMA: kernel reading files opened with O_DIRECT
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Christoph Hellwig <hch@infradead.org>, Jeff Moyer <jmoyer@redhat.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        akpm@linux-foundation.org, Al Viro <viro@zeniv.linux.org.uk>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, Lukas Czerner <lczerner@redhat>
Date: Wed, 16 Jul 2014 08:48:25 -0400
In-Reply-To: <20140715130308.GA4109@amd.pavel.ucw.cz>
References: <53B3D3AA.3000408@samsung.com>
	 <x49y4wbu54y.fsf@segfault.boston.devel.redhat.com>
	 <20140702184050.GA24583@infradead.org>
	 <20140711201054.GB18033@amd.pavel.ucw.cz>
	 <CACE9dm8TW1+7bq6hJiOmoAw+w+ZD8Ma=Sf6a5ZM2HZ5X1Lcifw@mail.gmail.com>
	 <20140715130308.GA4109@amd.pavel.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14071612-6688-0000-0000-000003543B7A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-15 at 15:03 +0200, Pavel Machek wrote: 
> On Sat 2014-07-12 01:22:04, Dmitry Kasatkin wrote:
> > On 11 July 2014 23:10, Pavel Machek <pavel@ucw.cz> wrote:
> > > On Wed 2014-07-02 11:40:50, Christoph Hellwig wrote:
> > >> On Wed, Jul 02, 2014 at 11:55:41AM -0400, Jeff Moyer wrote:
> > >> > It's acceptable.
> > >>
> > >> It's not because it will then also affect other reads going on at the
> > >> same time.
> > >>
> > >> The whole concept of ima is just broken, and if you want to do these
> > >> sort of verification they need to happen inside the filesystem and not
> > >> above it.

Agreed, maintaining the file's integrity hash should be done at the
filesystem layer.  IMA would then be relegated to using the integrity
information to maintain the measurement list and enforce local file
integrity.

> > > ...and doing it at filesystem layer would also permit verification of
> > > per-block (64KB? 1MB?) hashes.
> > 
> > Please design one single and the best universal filesystem which
> > does it.
> 
> Given the overhead whole-file hashing has, you don't need single best
> operating system. All you need it either ext4 or btrfs.. depending on
> when you want it in production.

Mike Halcrow will be leading a discussion on EXT4 Encryption at LSS
http://kernsec.org/wiki/index.php/Linux_Security_Summit_2014/Abstracts/Halcrow.
One of the discussion topics will be the storage of file metadata
integrity.  (Lukas Czerner's work.)  Hope you'll be able to attend.

Mimi

