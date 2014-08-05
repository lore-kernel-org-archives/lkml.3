Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbaHEB6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 21:58:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbaHEB6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 21:58:06 -0400
Date: Mon, 4 Aug 2014 21:57:58 -0400
From: Dave Jones <davej@redhat.com>
To: Chris Mason <clm@fb.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: btrfs extents related oops.
Message-ID: <20140805015758.GA9831@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20140805012845.GA7836@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140805012845.GA7836@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 09:28:45PM -0400, Dave Jones wrote:
 > Possibly related to some changes I've been making to my fuzz tester today
 > to operate on the same file from multiple threads.
 > This was on v3.16-829-g98959948a7ba, but probably exists on earlier trees too
 > given the lack of btrfs specific commits so far this merge window.

reproducer:

trinity -q -l off -c lseek -c write

(Things also go very, very bad if you then try to umount that
 partition - endless oopses, too mangled to parse).

	Dave

