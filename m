Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbaHDWQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 18:16:14 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710AbaHDWQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 18:16:12 -0400
Message-ID: <53E0062A.8030204@nod.at>
Date: Tue, 05 Aug 2014 00:16:10 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Ram Pai <linuxram@us.ibm.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Jeff Mahoney <jeffm@suse.com>, sahne@0x90.at,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: MNT_DETACH and mount namespace issue
References: <1406728756-32443-1-git-send-email-richard@sigma-star.at> <53D959A7.5070702@nod.at> <53DAC069.7070606@nod.at> <20140801154448.GE24719@ram.oc3035372033.ibm.com> <53DBE894.3020900@nod.at> <87ha1v6ewb.fsf@x220.int.ebiederm.org> <CAFLxGvzbdON+fbsG=0iwOv5m_hbQ2=Pz=Ec-AHq728FTNcx4iw@mail.gmail.com> <874mxs2of1.fsf@x220.int.ebiederm.org> <53DFF8E7.2060906@nod.at> <20140804221051.GH24719@ram.oc3035372033.ibm.com>
In-Reply-To: <20140804221051.GH24719@ram.oc3035372033.ibm.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 05.08.2014 00:10, schrieb Ram Pai:
> On Mon, Aug 04, 2014 at 11:19:35PM +0200, Richard Weinberger wrote:
>> Am 04.08.2014 18:46, schrieb Eric W. Biederman:
>>> Richard Weinberger <richard.weinberger@gmail.com> writes:
>>
>> /proc is propagating into another mount namespaces that does not care.
>> This happens because systemd creates for several services a mount namespace and sets
>> the root tree to MS_SHARED.
> 
> if propagations are not needed, than set the root of the new mount
> namespace to MS_PRIVATE first and then set it to MS_SHARED.
> 
> MS_PRIVATE will delink the propagations, and MS_SHARED later will enable
> the new mounts to propagate to whoever wants them.

AFAICT this would break systemd's PrivateTmp feature. :(
They want propagation. Such that a systemd service has a private /tmp but sees freshly
mounted filesystems after setting up the namespace.

Thanks,
//richard
