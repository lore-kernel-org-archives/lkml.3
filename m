Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbaHDWLE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 18:11:04 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:36990 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbaHDWLC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 18:11:02 -0400
Date: Mon, 4 Aug 2014 15:10:51 -0700
From: Ram Pai <linuxram@us.ibm.com>
To: Richard Weinberger <richard@nod.at>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Jeff Mahoney <jeffm@suse.com>, sahne@0x90.at,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: MNT_DETACH and mount namespace issue
Message-ID: <20140804221051.GH24719@ram.oc3035372033.ibm.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <1406728756-32443-1-git-send-email-richard@sigma-star.at>
 <53D959A7.5070702@nod.at>
 <53DAC069.7070606@nod.at>
 <20140801154448.GE24719@ram.oc3035372033.ibm.com>
 <53DBE894.3020900@nod.at>
 <87ha1v6ewb.fsf@x220.int.ebiederm.org>
 <CAFLxGvzbdON+fbsG=0iwOv5m_hbQ2=Pz=Ec-AHq728FTNcx4iw@mail.gmail.com>
 <874mxs2of1.fsf@x220.int.ebiederm.org>
 <53DFF8E7.2060906@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <53DFF8E7.2060906@nod.at>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080422-1542-0000-0000-000003C178E9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 11:19:35PM +0200, Richard Weinberger wrote:
> Am 04.08.2014 18:46, schrieb Eric W. Biederman:
> > Richard Weinberger <richard.weinberger@gmail.com> writes:
> 
> /proc is propagating into another mount namespaces that does not care.
> This happens because systemd creates for several services a mount namespace and sets
> the root tree to MS_SHARED.

if propagations are not needed, than set the root of the new mount
namespace to MS_PRIVATE first and then set it to MS_SHARED.

MS_PRIVATE will delink the propagations, and MS_SHARED later will enable
the new mounts to propagate to whoever wants them.

RP

